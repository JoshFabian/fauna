class SegmentConversation
  include Loggy

  # track events

  def self.track_conversation_create(conversation)
    raise Exception, "test environment" if Rails.env.test? or Rails.env.development?
    receipt = conversation.receipts.select{ |o| o.mailbox_type.match(/sent/) }.first
    hash = {user_id: receipt.receiver_id, event: 'Conversation Created', properties: {category: 'Conversation'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end