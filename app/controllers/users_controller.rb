class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:validate_email, :validate_handle]
  before_filter :admin_role_required!, only: [:become, :index]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @edit = @user.id == current_user.id
    @total_listings = @user.listings.count
    @recent_listings = @user.listings.order("id desc").limit(3)
    @cover_images = @user.cover_images.order("position asc").first(3)
    @blank_images = 3 - @cover_images.size
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @url = my_settings_path
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