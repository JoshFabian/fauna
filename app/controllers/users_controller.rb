class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:validate_email, :validate_handle]
  before_filter :admin_role_required!, only: [:become, :index]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /:handle
  def show
    @user = params[:handle].present? ? User.find_by_handle(params[:handle]) : User.find_by_id(params[:id])
    @edit = @user.id == current_user.id
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    @total_listings = @user.listings.approved.count
    @recent_listings = @user.listings.approved.order("id desc").limit(3)

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

    @listings = Listing.search(filter: {term: {user_id: @user.id}}).records

    @tab = 'listings'

    respond_to do |format|
      format.html { render(action: :show) }
    end
  end

  # GET /:handle/messages
  def messages
    @user = User.find_by_handle(params[:handle])
    @edit = @user.id == current_user.id
    @cover_images = @user.cover_images.order("position asc").first(3)
    @cover_set = 1.upto(3).map do |i|
      @cover_images.select{ |o| o.position == i }.first or i
    end

    @tab = 'messages'

    respond_to do |format|
      format.html { render(action: :show) }
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

end