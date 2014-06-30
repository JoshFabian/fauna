class ConversationObserver < ActiveRecord::Observer
  observe Conversation

  include Loggy

  def after_create(conversation)
    # puts "conversation:#{conversation.id} created"
  rescue Exception => e
  end
end