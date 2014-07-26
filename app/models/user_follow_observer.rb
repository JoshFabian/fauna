class UserFollowObserver < ActiveRecord::Observer
  include Loggy

  def after_create(user_follow)
    if user_follow.notify? and !user_follow.email_sent?
      # queue email
      Backburner::Worker.enqueue(UserEmailJob, Hashie::Mash.new(type: 'user_follow', id: user_follow.id), delay: 5.minutes)
    end
    # track segment io events
    SegmentUser.track_follow(user_follow)
  rescue Exception => e
  end

end