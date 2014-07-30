class WaitlistMailer < ActionMailer::Base
  default from: "Fauna Support <support@fauna.net>"

  def first_email(email, options={})
    @email = email
    @subject = options[:subject] || "Fauna early access"
    mail(to: @email, subject: @subject)
  end

  def first_buyer_email(email, options={})
    @email = email
    @subject = options[:subject] || "Fauna early access"
    mail(to: @email, subject: @subject)
  end

end