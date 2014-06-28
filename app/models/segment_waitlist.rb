class SegmentWaitlist
  include Loggy

  # track events

  def self.track_waitlist_added(waitlist)
    raise Exception, "test environment" if Rails.env.test? or Rails.env.development?
    result = track(user_id: waitlist.id, event: 'waitlist_added', properties: {category: 'Waitlist'})
    logger.post("tegu.app", log_data.merge({event: 'segmentio.waitlist_added', waitlist_id: waitlist.id}))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end