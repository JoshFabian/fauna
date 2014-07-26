class OauthsController < ApplicationController

  # GET /auth/facebook/callback?code=7122dbbf45
  # GET /auth/:provider/callback?code=7122dbbf45
  def callback
    # save omniauth env, without extra hash
    session["omniauth.auth"] = env["omniauth.auth"].except(:extra)
    # build oauth object
    @provider = params[:provider]
    @oauth = Oauth.from_omniauth(session["omniauth.auth"])
    logger.post("tegu.app", log_data.merge({event: "#{@provider}.oauth", oauth: @oauth}))
    if @oauth.persisted? and user_signed_in?
      # verify oauth user vs current user
      if @oauth.user_id != current_user.id
        logger.post("tegu.app", log_data.merge({event: "#{@provider}.error",
          message: "user:#{@oauth.user_id}, provider:#{@provider} already connected"}))
      else
        # user re-connected their account
        logger.post("tegu.app", log_data.merge({event: "#{@provider}.reconnect"}))
      end
      redirect_to(session[:oauth_return_to]) and return
    elsif @oauth.persisted? and !user_signed_in?
      # facebook oauth login
      logger.post("tegu.app", log_data.merge({event: "#{@provider}.login"}))
      # sign user in
      @user = @oauth.user
      sign_in(:user, @user)
      redirect_to(after_sign_in_path_for(@user)) and return
    elsif !@oauth.persisted? and user_signed_in?
      # user connected their account
      logger.post("tegu.app", log_data.merge({event: "#{@provider}.connect"}))
      redirect_to(session[:connect_oauth_return_to]) and return
    elsif !@oauth.persisted? and !user_signed_in?
      # facebook oauth signup as login credentials
      redirect_to(new_facebook_signup_path) and return
    end
  end

  # GET /auth/failure
  def failure
    redirect_to(root_path)
  end

end