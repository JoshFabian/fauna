class VerifyController < ApplicationController

  before_filter :authenticate_user!
  before_filter :manage_role_required!

  # :slug/verify
  def start
    @user = User.by_slug!(params[:slug])

    # set return_to paths
    session[:connect_oauth_return_to] = request.path
    session[:verify_paypal_return_to] = request.path
    session[:verify_phone_return_to] = request.path
  end

  # step 1
  # :slug/verify/paypal
  def paypal
    @user = User.by_slug!(params[:slug])
  end

  # step 2
  # :slug/verify/paypal/complete
  def paypal_complete
    redirect_to(session[:verify_paypal_return_to])
  end

end