class UserMailer < ActionMailer::Base
  default from: "Fauna Notifications <support@fauna.net>"

  def user_follow_email(user_follow, options={})
    @user = user_follow.user
    @following = user_follow.following
    @email = @following.email
    @subject = options[:subject] || "Fauna user follow"
    mail(to: @email, subject: @subject)
  end

end