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
        if @oauth.user_id != current_user.id
          logger.post("tegu.app", log_data.merge({event: 'facebook.error', message: "user #{@oauth.user_id} already connected"}))
        else
          # user connected their facebook account
          logger.post("tegu.app", log_data.merge({event: 'facebook.connect'}))
        end
        redirect_to(session[:oauth_return_to]) and return
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