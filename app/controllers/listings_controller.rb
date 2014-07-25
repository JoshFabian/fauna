class ListingsController < ApplicationController

  before_filter :authenticate_user!, only: [:new]
  before_filter :seller_verify!, only: [:new]
  before_filter :seller_paid!, only: [:new]
  before_filter :store_location!
  before_filter :admin_role_required!, only: [:manage]

  # GET /listings/manage
  def manage
    @listings = Listing.order('id desc').page(page).per(per)

    @title = "Manage Listings | Admin"

    respond_to do |format|
      format.html { render(layout: !request.xhr?) }
    end
  end

  # GET /listings/recent
  def recent
    @recent_general = Listing.active.order("id desc").limit(8)
    @recent_categories = Category.roots.with_listings.map do |category|
      mash = Hashie::Mash.new(category: category, listings: category.listings.active.order('id desc').limit(4))
    end

    @title = "Recent Listings"

    respond_to do |format|
      format.html
    end
  end

  # GET /listings/:category
  # GET /listings/:category/:subcategory
  def by_category
    token = params[:category].titleize.split.first
    subtoken = params[:subcategory].to_s.titleize.split.first
    @category = Category.roots.find_by_match(token)
    @subcategory = @category.children.find_by_match(subtoken) if subtoken.present?
    terms = [ListingFilter.category(@subcategory.present? ? @subcategory.id : @category.id), ListingFilter.state('active')]
    query = {filter: {bool: {must: terms}}, sort: {id: "desc"}}
    @listings = Listing.search(query).page(page).per(per).records

    @subcategories = @category.children.with_listings

    @title = [@category.name, @subcategory.try(:name)].compact.join(" : ") + " | Category"

    respond_to do |format|
      format.html { render(action: :index, layout: !request.xhr?) }
    end
  end

  # GET /listings/search
  def by_search
    begin
      @query = params[:query].to_s
      @listings = Listing.search(@query).page(page).per(per).records
    rescue Exception => e
      @listings = []
    end

    @title = "#{@query} | Search"

    respond_to do |format|
      format.html { render(action: :index, layout: !request.xhr?) }
    end
  end

  # GET /:slug/listings
  def by_user
    @user = User.by_slug(params[:slug])
    terms = [ListingFilter.user(@user.id), ListingFilter.state('active')]
    query = {filter: {bool: {must: terms}}, sort: {id: "desc"}}
    @listings = Listing.search(query).page(page).per(per).records

    @title = "Listings by #{@user.handle}"

    respond_to do |format|
      format.html { render(action: :index, layout: !request.xhr?) }
    end
  end

  # GET /listings/1
  # GET /:slug/listings/1
  def show
    if params[:slug].present?
      # find user listing
      @listing = User.friendly.find(params[:slug]).listings.friendly.find(params[:id])
    else
      # deprecated
      @listing = Listing.friendly.find(params[:id])
    end

    @message = params[:message]

    @owner = @listing.user
    @categories = @listing.categories
    @category = @categories.select{ |o| o.level == 1 }.first
    @subcategory = @categories.select{ |o| o.level == 2 }.first
    @all_images = @listing.images.order("position asc")
    @main_image = @all_images.first
    @reviews = @owner.listing_reviews.order("id desc").limit(10)

    # find owner's other listing and other listings
    @owner_listings = Listing.active.where(user_id: @owner.id).where.not(id: @listing.id).order("id desc").limit(2)
    @other_listings = Listing.active.where.not(user_id: @owner.id).order("id desc").limit(4)
    @other_listings = Listing.active.limit(4) if @other_listings.blank?

    @title = "#{@listing.title} | Listing"

    respond_to do |format|
      format.html
    end
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

  protected

  def page
    params[:page]
  end

  def per
    20
  end
end