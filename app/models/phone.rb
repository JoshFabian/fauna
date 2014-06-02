class Phone

  def self.send_sms(options={})
    config = Settings[Rails.env]
    client = Twilio::REST::Client.new(config[:sid], config[:token])
    message = client.account.messages.create(from: config[:from], to: options[:to], body: options[:body])
  end

end