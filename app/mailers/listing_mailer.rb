class ListingMailer < ActionMailer::Base
  default from: lambda { |s|  ListingMailer.default_from }

  def listing_flagged_email(listing, options={})
    @listing = listing
    @owner = @listing.user
    @subject = options[:subject] || "[Fauna] Your listing has been flagged"
    mail(to: @owner.email, subject: @subject)
  end

  protected

  def self.default_from
    if Rails.env.production?
      "Fauna Notifications <support@fauna.net>"
    else
      "Fauna Notifications #{Rails.env.titleize} <support@fauna.net>"
    end
  end

end