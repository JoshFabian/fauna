include Paddock

Paddock(Rails.env) do
  enable :user_messaging
  enable :user_feed
  disable :backburner_emails, in: [:test]
end