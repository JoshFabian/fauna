Settings.read("#{Rails.root}/config/app.yml")
Settings.read("#{Rails.root}/config/email.yml")
Settings.read("#{Rails.root}/config/facebook.yml")
Settings.read("#{Rails.root}/config/pp.yml")
Settings.read("#{Rails.root}/config/segmentio.yml")
Settings.read("#{Rails.root}/config/stripe.yml")
Settings.read("#{Rails.root}/config/twilio.yml")
Settings.read("#{Rails.root}/config/twitter.yml")

Settings.use :config_block
Settings.finally do |c|
  begin
    Key.get_names.each do |s|
      Settings[Rails.env][s] = Key.get_value(name: s)
    end
  rescue Exception => e
  end
end
Settings.resolve!

Tegu::Application.configure do
  if Rails.env.test?
    config.action_mailer.delivery_method = :test
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = { host: Settings[Rails.env][:email_host] }
  else
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { host: Settings[Rails.env][:email_host] }
    config.action_mailer.smtp_settings = {
      address: 'smtp.mandrillapp.com',
      port: 587,
      domain: 'fauna.net',
      user_name: Settings[Rails.env][:mandrillapp_username],
      password: Settings[Rails.env][:mandrillapp_password],
      enable_starttls_auto: false,
      openssl_verify_mode: "none"
      # authentication: :login,
    }
  end
end
