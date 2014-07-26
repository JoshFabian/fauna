class TestMailer < ActionMailer::Base
  default from: "test@fauna.net"

  def test_email(email, options={})
    @subject = options[:subject] || "Test Subject"
    mail(to: email, subject: @subject)
  end
end
