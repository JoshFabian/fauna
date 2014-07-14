class TestMailer < ActionMailer::Base
  default from: "tegu@fauna.net"

  def test_email(user)
    @user = user
    mail(to: @user.email, subject: 'Test Mailer')
  end
end
