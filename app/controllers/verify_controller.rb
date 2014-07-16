class VerifyController < ApplicationController

  before_filter :authenticate_user!
  before_filter :manage_role_required!

  # :handle/verify
  def start
    @user = User.by_handle(params[:handle])
  end

  # :handle/verify/email
  def email
    @user = User.by_handle(params[:handle])
  end

end