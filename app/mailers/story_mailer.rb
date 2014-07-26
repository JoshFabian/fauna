class StoryMailer < ActionMailer::Base
  default from: "Fauna Notifications <support@fauna.net>"

  def user_post_comment_email(comment, options={})
    @comment = comment
    @post = comment.commentable
    @poster = @post.user
    @email = @poster.email
    @commenter = comment.user
    @subject = options[:subject] || "Fauna comment"
    mail(to: @email, subject: @subject)
  end

end