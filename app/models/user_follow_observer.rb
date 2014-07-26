class UserFollowObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user_follow)
    if user_follow.notify? and !user_follow.email_sent? and feature(:backburner_emails)
      # queue email
      Backburner::Worker.enqueue(UserEmailJob, [{type: 'user_follow', id: user_follow.id}], delay: 3.minutes)
    end
    # track segment io events
    SegmentUser.track_follow(user_follow)
  rescue Exception => e
  end

end