case Rails.env
when 'development'
  host = "tegu.lvh.me"
when 'production'
  host = "www.fauna.net"
when 'staging'
  host = "staging.fauna.net"
else
  host = nil
end

if host.present?
  Tegu::Application.configure do
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = { host: host }
    config.action_mailer.smtp_settings = {
      address: 'smtp.mandrillapp.com',
      port: 587,
      user_name: Settings[Rails.env][:mandrillapp_username],
      password: Settings[Rails.env][:mandrillapp_password],
      domain: 'fauna.net'
    }
  end
end