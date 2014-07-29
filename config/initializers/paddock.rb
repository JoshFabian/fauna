include Paddock

Paddock(Rails.env) do
  enable :user_messaging
  enable :user_feed
  disable :story_facebook_share, in: [:production]
  disable :backburner_emails, in: [:test]
end