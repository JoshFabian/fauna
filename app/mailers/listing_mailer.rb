class ListingMailer < ActionMailer::Base
  default from: "Fauna Notifications <support@fauna.net>"

  def listing_flagged_email(listing, options={})
    @listing = listing
    @owner = @listing.user
    @subject = options[:subject] || "Your listing has been flagged"
    mail(to: @owner.email, subject: @subject)
  end

end