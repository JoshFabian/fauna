include Paddock

Paddock(Rails.env) do
  enable :user_messaging
  disable :user_feed, in: [:production]
end