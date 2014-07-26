class StoryMailer < ActionMailer::Base
  default from: "Fauna Notifications <support@fauna.net>"

  def user_listing_comment_email(comment, options={})
    @comment = comment
    @listing = comment.commentable
    @owner = @listing.user
    @email = @owner.email
    @commenter = comment.user
    @subject = options[:subject] || "Fauna comment"
    mail(to: @email, subject: @subject)
  end

  def user_post_comment_email(comment, options={})
    @comment = comment
    @post = comment.commentable
    @owner = @post.user
    @email = @owner.email
    @commenter = comment.user
    @subject = options[:subject] || "Fauna comment"
    mail(to: @email, subject: @subject)
  end

end