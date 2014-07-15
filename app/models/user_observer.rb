class UserObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user)
    # segment io events
    SegmentUser.identify(user)
    SegmentUser.track_signup(user)
  rescue Exception => e
  end

end