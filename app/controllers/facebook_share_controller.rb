class FacebookShareController < ApplicationController

  before_filter :authenticate_user!

  # GET /facebook/share/:klass/:id/auth
  def auth
    # set return_to paths
    session[:connect_oauth_return_to] = facebook_share_path(params[:klass], params[:id])

    redirect_to user_omniauth_authorize_path(:facebook)
  end


  # GET /facebook/share/:klass/:id/share
  def share
    # find object
    # @object = params[:klass].titleize.constantize.find(params[:id])

    # queue share
    Backburner::Worker.enqueue(FacebookShareJob, [{id: params[:id], klass: params[:klass]}])

    redirect_to(user_path(current_user))
  end

end