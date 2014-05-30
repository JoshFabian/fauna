class ListingsController < ApplicationController

  before_filter :authenticate_user!, only: [:new]

  # GET /listings
  def index
    @listings = Listing.all

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /listings/:category
  # GET /listings/:category/:subcategory
  def by_category
    @token = params[:category].titleize.split.first
    @subtoken = params[:subcategory].to_s.titleize.split.first
    # @categories = Category.search(query: {match: {name: @token}}, filter: {term: {level: 1}}).records
    # @category = @categories.first
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
      # @user = User.find_by_handle(params[:handle])
      # @listing = @user.listings.friendly.find(params[:id])
    else
      # deprecated
      @listing = Listing.friendly.find(params[:id])
    end

    @user = @listing.user
    @categories = @listing.categories
    @category = @categories.select{ |o| o.level == 1 }.first
    @subcategory = @categories.select{ |o| o.level == 2 }.first
    @main_image, *@other_images = @listing.images.order("position asc")
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
      format.html
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = current_user.listings.find(params[:id])
    @category = @listing.categories.where(level: 1).first
    @subcategory = @listing.categories.where(level: 2).first
    @images = @listing.images.order("position asc")

    @title = "Edit Listing"
    @root1_categories = Category.where(level: 1)
    @root2_categories = Category.where(level: 2, parent_id: @category.try(:id))

    respond_to do |format|
      format.html { render(action: :new) }
    end
  end

end