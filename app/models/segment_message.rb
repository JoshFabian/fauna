class SegmentMessage
  include Loggy

  # track events

  def self.track_message_create(message)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: message.sender_id, event: 'Message Created', properties: {category: 'Conversation'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end