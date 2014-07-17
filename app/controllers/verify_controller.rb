class VerifyController < ApplicationController

  before_filter :authenticate_user!
  before_filter :manage_role_required!

  # :slug/verify
  def start
    @user = User.by_slug(params[:slug])
  end

  # :slug/verify/email
  def email
    @user = User.by_slug(params[:slug])
  end

end