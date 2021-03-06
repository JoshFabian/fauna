class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:activity, :validate_email, :validate_handle]
  before_filter :admin_role_required!, only: [:become, :index]
  before_filter :manage_role_required!, only: [:messages, :purchases]
  before_filter :user_slug_normalize!, only: [:activity]

  # admins only
  # GET /users
  def index
    @users = User.order("id desc").page(params[:page]).per(20)

    @title = "Manage Users | Admin"

    respond_to do |format|
      format.html { render(layout: !request.xhr?) }
    end
  end

  # GET /users/1
  # GET /:slug
  def activity
    @user, @me, @cover_images, @cover_set, @image = user_profile_init

    @total_listings = @user.listings.active.count
    @recent_listings = @user.listings.active.order("id desc").limit(3)
    @recent_reviews = @user.listing_reviews.order("id desc").limit(4)
    @average_ratings = @user.listing_average_ratings

    @tab = 'home'
    @title = "#{@user.handle} | Profile"

    # set return_to paths
    session[:connect_oauth_return_to] = request.path

    respond_to do |format|
      format.html
    end
  end

  # GET /:slug/listings/manage
  # GET /:slug/listings/manage?category_id=1&state=active
  def manage_listings
    @user = User.by_slug!(params[:slug])
    acl_manage!(on: @user)
    @state = params[:state].present? ? params[:state] : 'active'
    @category_id = params[:category_id]
    terms = [ListingFilter.user(@user.id), ListingFilter.state(@state)]
    terms.push(ListingFilter.category(@category_id)) if @category_id.present?
    query = {filter: {bool: {must: terms}}, sort: {id: "desc"}}
    @listings = Listing.search(query).page(page).per(100).records

    @title = "#{@user.handle} | Manage Listings"
  end

  # GET /:slug/messages
  def messages
    @user, @me, @cover_images, @cover_set, @image = user_profile_init

    # optional mailbox label
    @label = params[:label] || 'inbox'
    # optional conversation id
    @conversation_id = params[:conversation].to_i

    @tab = 'messages'
    @title = "#{@user.handle} | Messages"

    respond_to do |format|
      format.html
    end
  end

  # GET /:slug/purchases
  def purchases
    @user, @me, @cover_images, @cover_set, @image = user_profile_init
    # @user = User.by_slug!(params[:slug])

    @user_purchases = @user.purchases
    @user_reviews = @user.authored_reviews

    @title = "#{@user.handle} | Purchases"

    respond_to do |format|
      format.html
    end
  end

  # GET /:slug/reviews
  def reviews
    @user, @me, @cover_images, @cover_set, @image = user_profile_init

    @reviews = @user.listing_reviews

    @tab = 'reviews'
    @title = "#{@user.handle} | Reviews"

    respond_to do |format|
      format.html
    end
  end

  # GET /:slug/settings
  def settings
    @user = User.by_slug(params[:slug]) || User.find(params[:id])
    # @url = user_path(@user)

    # set return_to paths
    session[:connect_oauth_return_to] = request.path
    session[:verify_paypal_return_to] = request.path
    session[:verify_phone_return_to] = request.path

    @title = "My Settings"

    respond_to do |format|
      format.html
    end
  end

  # GET /:slug/store
  # GET /:slug/store/category/:category
  # POST /:slug/store/search?query=q
  def store
    @user, @me, @cover_images, @cover_set, @image = user_profile_init

    terms = [ListingFilter.user(@user.id), ListingFilter.state('active')]
    sort = {id: 'desc'}

    if params[:category].present?
      @category = Category.roots.find_by_slug(params[:category])
      # add category filter
      terms.push(ListingFilter.category(@category.try(:id)))
      @store_title = [@category.try(:name)].compact.join(' ')
    elsif params[:query].present?
      # add match query
      @query = params[:query].to_s
      @match = Hashie::Mash.new(match: {'_all' => {query: Search.wildcard_query(@query), minimum_should_match: '75%'}})
      @store_title = ['Search Results'].compact.join(' ')
    else
      @store_title = ['All Listings'].compact.join(' ')
    end

    # build search query
    query = Hashie::Mash.new(filter: {bool: {must: terms}}, sort: sort)
    query.query = @match if @match.present?
    @listings = Listing.search(query).page(page).per(per).records
    # get user's listing category ids
    @category_ids = @user.listing_category_ids

    @tab = 'store'
    @title = "#{@user.handle} | Store"

    respond_to do |format|
      format.html { render(layout: !request.xhr?) }
    end
  end

  # deprecated
  # GET /:slug/store/category/:category
  # POST /:slug/store/search?query=q
  # def store_by_filter
  #   @user, @me, @cover_images, @cover_set, @image = user_profile_init
  # 
  #   # build terms
  #   terms = [ListingFilter.user(@user.id), ListingFilter.state('active')]
  # 
  #   if params[:category].present?
  #     @category = Category.roots.find_by_slug(params[:category])
  #     # add category term
  #     terms.push(ListingFilter.category(@category.try(:id)))
  #     query = {filter: {bool: {must: terms}}, sort: {id: "desc"}}
  #   elsif params[:query].present?
  #     # add match query
  #     @query = params[:query].to_s
  #     query = {query: {match: {'_all' => Search.wildcard_query(@query)}}, filter: {bool: {must: terms}}}
  #   end
  # 
  #   @listings = Listing.search(query).page(page).per(per).records
  #   @category_ids = @user.listing_category_ids
  #   @tab = 'store'
  #   @store_title = [@category.present? ? @category.try(:name) : "Search Results"].compact.join(' ')
  # 
  #   @title = "#{@user.handle} | Store"
  # 
  #   respond_to do |format|
  #     format.html { render(action: :store, layout: !request.xhr?) }
  #   end
  # end

  # GET /users/1/edit
  # GET /:slug/edit
  def edit
    @user = User.by_slug(params[:slug]) || User.find(params[:id])
    @url = user_path(@user)
    @title = "My Profile"

    respond_to do |format|
      format.html
    end
  end

  # GET /signup/validate_email
  def validate_email
    # validate uniqueness of field
    @email = params[:user].try(:[], :email)
    @query = User.where(:email => @email)
    @query = @query.where.not(id: current_user.id) if user_signed_in?

    if @query.count > 0
      @status = '"Email has already been taken"'
    else
      @status = 'true'
    end
  rescue Exception => e
    @status = 'false'
  ensure
    respond_to do |format|
      format.json { render(:json => @status) }
    end
  end

  # GET /signup/validate_handle
  def validate_handle
    # validate uniqueness of field
    @handle = params[:user].try(:[], :handle)
    @query = User.where(:handle => @handle)
    @query = @query.where.not(id: current_user.id) if user_signed_in?

    if @query.count > 0
      @status = '"Username has already been taken"'
    else
      @status = 'true'
    end
  rescue Exception => e
    @status = 'false'
  rescue Exception => e
    @status = 'false'
  ensure
    respond_to do |format|
      format.json { render(:json => @status) }
    end
  end

  # GET /users/1/become
  def become
    @user = User.find(params[:id])
    sign_in(:user, @user)
    # @gflash = {success: {value: "You are now logged in as #{@user.handle}", time: 3000}}
    redirect_to(root_path) and return
  end

  protected

  # shared helper method
  def user_profile_init
    user = User.by_slug(params[:slug]) || User.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound if user.blank?
    me = user.id == current_user.try(:id)
    cover_images = user.cover_images.order("position asc").first(3)
    cover_set = 1.upto(3).map do |i|
      cover_images.select{ |o| o.position == i }.first or i
    end
    image = cover_images.first || user.avatar_image
    [user, me, cover_images, cover_set, image]
  end

  def page
    params[:page]
  end

  def per
    20
  end
end