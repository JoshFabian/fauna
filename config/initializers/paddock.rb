include Paddock

Paddock(Rails.env) do
  enable :story_facebook_share
  disable :listing_card, in: [:production]
  disable :backburner, in: [:test]
  disable :backburner_emails, in: [:test]
end