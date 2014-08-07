class FacebookShareController < ApplicationController

  before_filter :authenticate_user!

  # GET /facebook/share/:klass/:id/auth
  # GET /facebook/share/:klass/:id/auth/from/:page
  def auth
    # set return_to paths
    session[:connect_oauth_return_to] = facebook_share_path(params[:klass], params[:id], params[:page])

    redirect_to user_omniauth_authorize_path(:facebook)
  end


  # GET /facebook/share/:klass/:id/share
  # GET /facebook/share/:klass/:id/share/from/:page
  def share
    # find object
    object = params[:klass].titleize.constantize.find(params[:id])

    # queue share
    Backburner::Worker.enqueue(FacebookShareJob, [{id: params[:id], klass: params[:klass]}])

    if params[:page].present?
      if params[:page].to_s.match(/listing/)
        goto = user_listing_path(current_user, object)
      elsif params[:page].match(/feed|story/)
        goto = user_path(current_user)
      end
    else
      goto = user_path(current_user)
    end

    redirect_to goto and return
  end

end