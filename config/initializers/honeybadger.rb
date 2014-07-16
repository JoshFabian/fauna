Honeybadger.configure do |config|
  config.api_key = Settings[Rails.env][:honeybadger_api_key]
end
