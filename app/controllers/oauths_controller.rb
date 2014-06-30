class OauthsController < ApplicationController

  # GET /auth/facebook/callback?code=7122dbbf45
  def callback
    # save omniauth env, without extra hash
    session["omniauth.auth"] = env["omniauth.auth"].except(:extra)
    # build oauth object
    @oauth = Oauth.from_omniauth(session["omniauth.auth"])
    logger.post("tegu.app", log_data.merge({event: 'facebook.oauth', oauth: @oauth}))
    if @oauth.persisted?
      if user_signed_in?
        logger.post("tegu.app", log_data.merge({event: 'facebook.connect'}))
        # user connected their facebook account
        redirect_to(user_verify_path(current_user))
      else
        logger.post("tegu.app", log_data.merge({event: 'facebook.login'}))
        # user exists, sign them in
        @user = @oauth.user
        sign_in(:user, @user)
        redirect_to(after_sign_in_path_for(@user)) and return
      end
    else
      logger.post("tegu.app", log_data.merge({event: 'facebook.signup'}))
      # redirect
      redirect_to(new_facebook_signup_path) and return
    end
  end

  # GET /auth/failure
  def failure
    redirect_to(root_path)
  end

end