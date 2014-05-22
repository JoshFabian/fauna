module LoggerHelper
  def logger
    Fluent::Logger
  end

  def log_data
    {:timestamp => Time.now.utc.to_s(:standard), :path => request.path, :token => params[:token],
     :user_id => current_user_id}
  end
end

class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  helpers LoggerHelper
  mount Endpoints::WaitlistApi
end