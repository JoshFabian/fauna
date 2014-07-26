class UserEmailJob
  include Backburner::Queue
  include Loggy
  queue "emails"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(mash)
    if mash.type == 'user_follow'
      user_follow = UserFollow.find_by_id(mash.id)
      return 0 if user_follow.blank?
      # send email
      UserMailer.user_follow_email(user_follow).deliver
      # mark email sent flag
      user_follow.update(email_sent: 1)
      return 1
    end
  rescue Exception => e
    0
  end

end