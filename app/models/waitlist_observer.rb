class WaitlistObserver < ActiveRecord::Observer
  include Loggy

  def after_create(object)
    Waitlist.where(code: object.referer).each do |waitlist|
      waitlist.increment!(:signup_count)
    end
    SegmentWaitlist.track_waitlist_added(object)
    logger.post("tegu.app", log_data.merge({event: "waitlist.add", waitlist_id: object.id}))
  rescue Exception => e
  end

end