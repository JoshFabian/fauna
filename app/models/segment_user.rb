class SegmentUser
  include Loggy

  # identify user to segment io
  def self.identify(user)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: user.id, traits: {name: user.full_name, email: user.email, created_at: user.created_at}}
    result = Analytics.identify(hash)
    logger.post("tegu.app", log_data.merge({event: 'segmentio.identify', user_id: user.id}))
    result
  rescue Exception => e
    false
  end

  # track events

  def self.track_signup(user)
    raise Exception, "test environment" if Rails.env.test?
    result = track(user_id: user.id, event: 'signup')
    logger.post("tegu.app", log_data.merge({event: 'segmentio.signup', user_id: user.id}))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end
