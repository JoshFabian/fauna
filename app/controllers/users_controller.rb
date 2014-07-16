class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :validate_email, :validate_handle]
  before_filter :admin_role_required!, only: [:become, :index]
  before_filter :manage_role_required!, only: [:messages, :purchases]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /:handle
  def show
    @user = User.by_handle(params[:handle].present? ? params[:handle] : params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    @edit = @user.id == current_user.try(:id)
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    @total_listings = @user.listings.active.count
    @recent_listings = @user.listings.active.order("id desc").limit(3)
    @recent_reviews = @user.listing_reviews.order("id desc").limit(4)
    @average_ratings = @user.listing_average_ratings

    @tab = 'home'

    respond_to do |format|
      format.html
    end
  end

  # GET /:handle/listings
  def listings
    @user = User.find_by_handle(params[:handle])
    @edit = @user.id == current_user.id
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    @listings = @user.listings.active.order("id desc").limit(50)
    # @listings = Listing.search(filter: {term: {user_id: @user.id}}).records

    @tab = 'listings'

    respond_to do |format|
      format.html { render(action: :show) }
    end
  end

  # GET /:handle/listings/manage
  # GET /:handle/listings/manage?category_id=1&state=active
  def manage_listings
    @user = User.find_by_handle(params[:handle])
    acl_manage!(on: @user)
    @state = params[:state].present? ? params[:state] : 'active'
    @category_id = params[:category_id]
    @terms = [{term: {user_id: @user.id}}]
    if @category_id.present?
      @terms.push({term: {category_ids: @category_id}})
    end
    @filter = {filter: {bool: {must: @terms}}}
    @listings = Listing.search(@filter).records.where(state: @state)
  end

  # GET /:handle/messages
  def messages
    @user = User.find_by_handle(params[:handle])
    @edit = @user.id == current_user.id
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    # optional mailbox label
    @label = params[:label] || 'inbox'
    # optional conversation id
    @conversation_id = params[:conversation].to_i

    @tab = 'messages'

    respond_to do |format|
      format.html { render(action: :show) }
    end
  end

  # GET /:handle/purchases
  def purchases
    @user = User.find_by_handle(params[:handle])

    @user_purchases = @user.purchases
    @user_reviews = @user.authored_reviews

    respond_to do |format|
      format.html
    end
  end

  # GET /:handle/reviews
  def reviews
    @user = User.find_by_handle(params[:handle])
    @edit = @user.id == current_user.id
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    @reviews = @user.listing_reviews

    @tab = 'reviews'

    respond_to do |format|
      format.html { render(action: :show) }
    end
  end

  # GET /users/1/edit
  # GET /:handle/edit
  def edit
    @user = User.find_by_handle(params[:handle]) || User.find(params[:id])
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

end