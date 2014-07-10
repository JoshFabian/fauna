Backburner.configure do |config|
  config.beanstalk_url = "beanstalk://127.0.0.1"
  config.tube_namespace = "fauna.#{Rails.env}"
  # config.logger = Fluent::Logger
end