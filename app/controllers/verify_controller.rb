class VerifyController < ApplicationController

  before_filter :authenticate_user!

  # :handle/verify
  def start
    @user = User.find_by_handle(params[:handle])
  end

  # :handle/verify/email
  def email
    @user = User.find_by_handle(params[:handle])
  end

end