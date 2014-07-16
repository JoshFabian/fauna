class TestMailer < ActionMailer::Base
  default from: "test@fauna.net"

  def test_email(user, options={})
    @user = user
    @subject = options[:subject] || "Test Subject"
    mail(to: @user.email, subject: @subject)
  end
end
