class ConversationObserver < ActiveRecord::Observer
  observe Conversation, Message

  include Loggy

  def after_create(object)
    if object.is_a?(Conversation)
      # conversation created
      logger.post("tegu.app", log_data.merge({event: 'conversation.created', id: object.id}))
    end
    if object.is_a?(Message)
      # message created
      logger.post("tegu.app", log_data.merge({event: 'message.created', id: object.id}))
      # update inbox unread count for each participant
      # object.conversation.participants.each do |user|
      #   inbox_unread_count = user.mailbox.inbox.unread(user).count
      #   # puts "user:#{user.id}, unread:#{inbox_unread_count}"
      #   user.update_attributes(inbox_unread_count: inbox_unread_count)
      # end
    end
  rescue Exception => e
  end
end