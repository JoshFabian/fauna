class WaitlistObserver < ActiveRecord::Observer
  include Loggy

  def after_create(object)
    Waitlist.where(code: object.referer).each do |waitlist|
      waitlist.increment!(:signup_count)
    end
  rescue Exception => e
  end

end