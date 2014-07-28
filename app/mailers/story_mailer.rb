class StoryMailer < ActionMailer::Base
  default from: "Fauna Notifications <support@fauna.net>"

  def user_listing_comment_email(comment, options={})
    @comment = comment
    @listing = comment.commentable
    @owner = @listing.user
    @commenter = comment.user
    @subject = options[:subject] || "New Fauna comment on your listing '#{@listing.title.truncate(10)}'"
    mail(to: @owner.email, subject: @subject)
  end

  def user_post_comment_email(comment, options={})
    @comment = comment
    @post = comment.commentable
    @owner = @post.user
    @commenter = comment.user
    @subject = options[:subject] || "New Fauna comment on your post"
    mail(to: @owner.email, subject: @subject)
  end

end