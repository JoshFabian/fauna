class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Loggy

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActionController::UnknownFormat do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || listings_path
  end

  def after_sign_out_path_for(resource)
    login_path
  end

  def admin_role_required!
    raise CanCan::AccessDenied, "Unauthorized" unless user_signed_in? and current_user.roles?(:admin)
  end

end
