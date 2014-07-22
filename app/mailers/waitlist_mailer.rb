class WaitlistMailer < ActionMailer::Base
  default from: "Fauna Support <support@fauna.net>"

  def first_email(user, options={})
    @user = user
    @subject = options[:subject] || "Test Subject"
    mail(to: @user.email, subject: @subject)
  end

end