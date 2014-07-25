class UserFollowObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user_follow)
    # segment io events
    SegmentUser.track_follow(user_follow)
  rescue Exception => e
  end

end