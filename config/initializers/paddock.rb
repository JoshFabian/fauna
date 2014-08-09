include Paddock

Paddock(Rails.env) do
  disable :listing_card, in: [:production]
  disable :story_facebook_share, in: [:production]
  disable :backburner, in: [:test]
  disable :backburner_emails, in: [:test]
end