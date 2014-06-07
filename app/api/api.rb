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
    {timestamp: Time.now.utc.to_s(:standard), path: request.path, token: params[:token], user_id: current_user_id,
     env: Rails.env}
  end
end

class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  helpers AuthHelper
  helpers LoggerHelper
  mount Endpoints::ListingApi
  mount Endpoints::PaypalApi
  mount Endpoints::PingApi
  mount Endpoints::SmsApi
  mount Endpoints::StripeApi
  mount Endpoints::UserApi
  mount Endpoints::WaitlistApi
end