class SegmentConversation
  include Loggy

  # track events

  def self.track_conversation_created(conversation)
    raise Exception, "test environment" if Rails.env.test? or Rails.env.development?
    receipt = conversation.receipts.select{ |o| o.mailbox_type.match(/sent/) }.first
    result = track(user_id: receipt.receiver_id, event: 'conversation_created')
    logger.post("tegu.app", log_data.merge({event: 'segmentio.conversation_created', conversation_id: conversation.id}))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end