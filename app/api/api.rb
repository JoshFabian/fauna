module AuthHelper
  def current_user
    @current_user ||= User.find_by_authentication_token(params[:token])
  end

  def current_user_id
    @current_user_id ||= current_user.try(:id).to_i
  end

  def authenticate!
    error!('401 Unauthorized', 401) unless current_user.present?
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
  mount Endpoints::ImageApi
  mount Endpoints::ListingApi
  mount Endpoints::MessageApi
  mount Endpoints::PaymentApi
  mount Endpoints::PaypalApi
  mount Endpoints::PingApi
  mount Endpoints::PlanApi
  mount Endpoints::ReportApi
  mount Endpoints::SmsApi
  mount Endpoints::StripeApi
  mount Endpoints::TrackingApi
  mount Endpoints::UserApi
  mount Endpoints::WaitlistApi
end