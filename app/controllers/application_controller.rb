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

  def acl_editable!(options={})
    raise CanCan::AccessDenied, "Unauthorized" if !options[:on].editable?
  end

  def acl_manage!(options={})
    raise CanCan::AccessDenied, "Unauthorized" if !acl_manage?(options)
  end

  def acl_manage?(options={})
    return true if current_user.roles?(:admin)
    if options[:on].present?
      if options[:on].is_a?(Listing)
        current_user.id == options[:on].user_id
      elsif options[:on].is_a?(User)
        current_user == options[:on]
      else
        false
      end
    end
  rescue Exception => e
    false
  end

  def admin_role_required!
    raise CanCan::AccessDenied, "Unauthorized" unless user_signed_in? and current_user.roles?(:admin)
  end

  def seller_credits!
    redirect_to plans_path if current_user.listing_credits == 0
    true
  end

  def seller_paid!
    redirect_to plans_path if current_user.listing_credits == 0 and current_user.subscriptions_count == 0 
    true
  end

  def seller_subscribed!
    redirect_to plans_path if current_user.subscriptions_count == 0
    true
  end

  def seller_verify!
    redirect_to user_verify_path(current_user) if !current_user.verified?
    true
  end

end
