Settings.read("#{Rails.root}/config/app.yml")
Settings.read("#{Rails.root}/config/segmentio.yml")
Settings.read("#{Rails.root}/config/stripe.yml")
Settings.read("#{Rails.root}/config/twilio.yml")

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