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
  def by_category
    @category = params[:category]
    @listings = Listing.search(filter: {term: {category_names: @category}}).records

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
  def show
    @listing = Listing.friendly.find(params[:id])
    @images = @listing.images.order("position asc")
    @main_image = @images.first
    @images = @images.last(4)
  end

  # GET /listings/new
  def new
    @listing = current_user.listings.new
    @images = @listing.images
    @categories = @listing.categories.where(level: 1)
    @subcategories = @listing.categories.where(level: 2)

    @title = "Create New Listing"
    @root1_categories = Category.where(level: 1)
    @root2_categories = Category.where(level: 2)

    respond_to do |format|
      format.html
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = current_user.listings.find(params[:id])
    @images = @listing.images.order("position asc")
    @categories = @listing.categories.where(level: 1)
    @subcategories = @listing.categories.where(level: 2)

    @title = "Edit Listing"
    @root1_categories = Category.where(level: 1)
    @root2_categories = Category.where(level: 2)

    respond_to do |format|
      format.html { render(action: :new) }
    end
  end

end