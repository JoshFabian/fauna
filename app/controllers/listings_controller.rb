class ListingsController < ApplicationController

  before_filter :authenticate_user!, only: [:new]

  # GET /listings
  def index
    @listings = Listing.all
  end

  # GET /listings/:category
  def by_category
    @category = params[:category]
    @listings = Listing.search(filter: {term: {category_names: @category}}).records

    respond_to do |format|
      format.html { render(action: :index) }
    end
  end

  # GET /listings/1
  def show
    @listing = Listing.find(params[:id])
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