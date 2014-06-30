class ListingsController < ApplicationController

  before_filter :authenticate_user!, only: [:new]
  before_filter :seller_verify!, only: [:new]
  before_filter :seller_paid!, only: [:new]

  # GET /listings
  def index
    @listings = Listing.active.all

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /listings/recent
  def recent
    @recent_general = Listing.active.order("id desc").limit(8)
    @recent_categories = Category.roots.map do |category|
      mash = Hashie::Mash.new(category: category, listings: category.listings.active.order('id desc').limit(4))
    end

    respond_to do |format|
      format.html
    end
  end

  # GET /:handle/listings/manage
  # GET /:handle/listings/manage?category_id=1&state=active
  def manage
    @state = params[:state].present? ? params[:state] : 'active'
    @category_id = params[:category_id]
    @user = User.find_by_handle(params[:handle])
    acl_manage!(on: @user)
    @listings = @user.listings.where(state: @state)
    if @category_id.present?
      @listings = @listings.search(filter: {term: {category_ids: @category_id}}).records
    end
    # @listings = Listing.search(filter: {term: {user_id: @user.id}}).records.where(state: @state)
  end

  # GET /listings/:category
  # GET /listings/:category/:subcategory
  def by_category
    @token = params[:category].titleize.split.first
    @subtoken = params[:subcategory].to_s.titleize.split.first
    @category = Category.roots.find_by_match(@token)
    @subcategory = @category.children.find_by_match(@subtoken) if @subtoken.present?
    @category_ids = @subcategory.present? ? @subcategory.id : @category.id
    @listings = Listing.search(filter: {term: {category_ids: @category_ids}}).records

    @subcategories = @category.children

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /listings/search
  def by_search
    @query = params[:query].to_s
    @listings = Listing.search(@query).records

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /:handle/listings
  def by_user
    @user = User.find_by_handle(params[:handle])
    @listings = Listing.search(filter: {term: {user_id: @user.id}}).records

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /listings/1
  # GET /:handle/listings/1
  def show
    if params[:handle].present?
      # find user listing
      @listing = User.friendly.find(params[:handle]).listings.friendly.find(params[:id])
    else
      # deprecated
      @listing = Listing.friendly.find(params[:id])
    end

    @message = params[:message]

    @user = @listing.user
    @categories = @listing.categories
    @category = @categories.select{ |o| o.level == 1 }.first
    @subcategory = @categories.select{ |o| o.level == 2 }.first
    @all_images = @listing.images.order("position asc")
    @main_image = @all_images.first
    @reviews = @listing.reviews

    @other_listings = current_user.listings.active.where.not(id: @listing.id).order("id desc").limit(2)
  end

  # GET /listings/new
  def new
    @listing = current_user.listings.new
    @category = []
    @subcategory = []
    @images = []

    @title = "Create New Listing"
    @root1_categories = Category.where(level: 1)
    @root2_categories = []

    respond_to do |format|
      format.html { render(action: :edit) }
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = current_user.listings.friendly.find(params[:id])
    acl_manage!(on: @listing)
    acl_editable!(on: @listing)
    @category = @listing.categories.where(level: 1).first
    @subcategory = @listing.categories.where(level: 2).first
    @images = @listing.images.order("position asc")

    @title = "Edit Listing"
    @root1_categories = Category.where(level: 1)
    @root2_categories = Category.where(level: 2, parent_id: @category.try(:id))

    respond_to do |format|
      format.html
    end
  end

end