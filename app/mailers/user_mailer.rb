class UserMailer < ActionMailer::Base
  default from: lambda { |s|  StoryMailer.default_from }

  def user_follow_email(user_follow, options={})
    @user = user_follow.user
    @following = user_follow.following
    @email = @following.email
    @subject = options[:subject] || "Fauna user follow"
    mail(to: @email, subject: @subject)
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