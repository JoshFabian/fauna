class OauthsController < ApplicationController

  # GET /auth/facebook/callback?code=7122dbbf45
  def callback
    # save omniauth env, without extra hash
    session["omniauth.auth"] = env["omniauth.auth"].except(:extra)
    # build oauth object
    @oauth = Oauth.from_omniauth(session["omniauth.auth"])
    if @oauth.persisted?
      if user_signed_in?
        # user connected their facebook account
        redirect_to(user_verify_path(current_user))
      else
        # user exists, sign them in
        @user = @oauth.user
        sign_in(:user, @user)
        redirect_to(after_sign_in_path_for(@user)) and return
      end
    else
      # redirect
      redirect_to(new_facebook_signup_path) and return
    end
  end
  
  # GET /auth/failure
  def failure
    redirect_to(root_path)
  end

end