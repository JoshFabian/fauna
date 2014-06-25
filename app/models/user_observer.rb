class UserObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user)
    SegmentUser.identify(user)
    SegmentUser.track_signup(user)
  rescue Exception => e
  end

end