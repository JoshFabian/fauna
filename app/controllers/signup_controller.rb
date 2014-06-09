class SignupController < ApplicationController
  respond_to :html

  # before_filter :check_invite!, only: [:create_facebook, :create_password]

  # GET /signup
  def new
    redirect_to new_password_signup_path
  end

  # GET /signup/new/facebook
  def new_facebook
    # build user object from omniauth
    @user = User.from_omniauth(session["omniauth.auth"])
    @code = params[:code]
    @url = create_facebook_signup_path
    @title = "Complete Signup"

    respond_to do |format|
      format.html { render(template: "users/edit") }
    end
  end

  # GET /signup/new/password
  def new_password
    # build user object
    @user = User.new
    @code = params[:code]
    @url = create_password_signup_path
    @title = "Complete Signup"

    respond_to do |format|
      format.html { render(template: "users/edit") }
    end
  end

  # POST /signup/new/facebook
  def create_facebook
    # create user
    @user = User.create(user_params)
    # build oauth and save
    @oauth = Oauth.from_omniauth(session["omniauth.auth"].merge(user_id: @user.id))
    @oauth.save
    # track invite
    # current_invite.signup!(@user) if current_invite
    # sign user in
    sign_in(:user, @user)
    respond_with @user, location: after_sign_in_path_for(@user)
  end

  # POST /signup/new/password
  def create_password
    # create user
    @user = User.create(user_params)
    # track invite
    current_invite.signup!(@user) if current_invite
    # sign user in
    sign_in(:user, @user)
    respond_with @user, location: after_sign_in_path_for(@user)
  end

  protected

  def user_params
    params.require(:user).permit(:email, :first_name, :handle, :last_name, :password, :password_confirmation)
  end
  
end