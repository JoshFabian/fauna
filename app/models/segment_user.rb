class SegmentUser
  include Loggy

  # identify user to segment io
  def self.identify(user)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: user.id, traits: {name: user.full_name, email: user.email, created_at: user.created_at}}
    result = Analytics.identify(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  # track events

  def self.track_signup(user)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: user.id, event: 'User Signup', properties: {category: 'User', label: user.handle}}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_login(user)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: user.id, event: 'User Login', properties: {category: 'User', label: user.handle}}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_profile_view(user, options={})
    raise Exception, "test environment" if Rails.env.test?
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'User Profile View', properties: {category: 'User', label: user.handle}}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_follow(user_follow, options={})
    raise Exception, "test environment" if Rails.env.test?
    user_id = user_follow.user_id
    hash = {user_id: user_id, event: 'User Follow', properties: {category: 'User', label: user_follow.following.handle}}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end
