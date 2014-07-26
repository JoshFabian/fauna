class UserFollowObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user_follow)
    if !user_follow.email_sent?
      # send user follow email
      UserMailer.user_follow_email(user_follow).deliver
    end
    # segment io events
    SegmentUser.track_follow(user_follow)
  rescue Exception => e
  end

end