# case Rails.env
# when 'development'
#   host = "tegu.lvh.me"
# when 'production'
#   host = "www.fauna.net"
# when 'staging'
#   host = "staging.fauna.net"
# else
#   host = nil
# end

if true#host.present?
  Tegu::Application.configure do
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.default_url_options = { host: Settings[Rails.env][:email_host] }
    config.action_mailer.smtp_settings = {
      address: 'smtp.mandrillapp.com',
      port: 587,
      domain: 'fauna.net',
      user_name: Settings[Rails.env][:mandrillapp_username],
      password: Settings[Rails.env][:mandrillapp_password],
      # authentication: :login,
      # enable_starttls_auto: true
      # openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end

  # Rails.application.routes.default_url_options[:host] = host
end