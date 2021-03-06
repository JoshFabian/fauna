module AuthHelper
  def current_session
    @current_session ||= Hashie::Mash.new(id: params.session_token)
  end

  def current_user
    @current_user ||= User.find_by_authentication_token(params[:token])
  end

  def current_user_id
    @current_user_id ||= current_user.try(:id).to_i
  end

  def authenticate!
    error!('401 Unauthorized', 401) unless current_user.present?
  end

  def acl_admin?(options={})
    current_user.roles?(:admin) ? true : false
  rescue Exception => e
    false
  end

  def acl_admin!(options={})
    error! 'Unauthorized', 401 if !acl_admin?(options)
  end

  def acl_manage?(options={})
    return true if acl_admin?(options)
    return false if options[:on].blank?
    if options[:on].is_a?(Listing)
      return true if options[:on].user_id == current_user_id
    end
    false
  rescue Exception => e
    false
  end

  def acl_manage!(options={})
    error! 'Unauthorized', 401 if !acl_manage?(options)
  end

end

module LoggerHelper
  def logger
    Fluent::Logger
  end

  def log_data
    {env: Rails.env, timestamp: Time.now.utc.to_s(:standard), params: params.except(:route_info), path: request.path,
     token: params.token, user_id: current_user_id}
  end

  def log_data_min
    log_data.except(:params)
  end
end

class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  helpers AuthHelper
  helpers LoggerHelper
  mount Endpoints::ChartApi
  mount Endpoints::ImageApi
  mount Endpoints::ListingApi
  mount Endpoints::MessageApi
  mount Endpoints::PaymentApi
  mount Endpoints::PaypalApi
  mount Endpoints::PingApi
  mount Endpoints::PlanApi
  mount Endpoints::PostApi
  mount Endpoints::ReportApi
  mount Endpoints::SmsApi
  mount Endpoints::StripeApi
  mount Endpoints::TrackingApi
  mount Endpoints::UserApi
  mount Endpoints::WaitlistApi
end