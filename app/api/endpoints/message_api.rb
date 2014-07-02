module Endpoints
  class MessageApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :conversations do
      desc "Mark conversations as read"
      put ':ids/read' do
        authenticate!
        ids = params.ids.split(',').map(&:to_i)
        objects = ids.inject([]) do |objects, id|
          begin
            conversation = Conversation.find(id)
            conversation.mark_as_read(current_user)
            objects.push({id: id, event: 'read'})
          rescue Exception => e
          end
          objects
        end
        logger.post("tegu.api", log_data.merge({event: 'conversations.read', conversation_ids: ids.join(',')}))
        {conversations: objects}
      end

      desc "Mark conversation as trashed or untrashed"
      put ':ids/:label', requirements: {label: /trash|untrash/} do
        authenticate!
        ids = params.ids.split(',').map(&:to_i)
        objects = ids.inject([]) do |objects, id|
          begin
            conversation = Conversation.find(id)
            if params.label == 'trash'
              conversation.mark_as_read(current_user)
              conversation.move_to_trash(current_user)
              objects.push({id: id, event: 'trashed'})
            elsif params.label == 'untrash'
              conversation.untrash(current_user)
              objects.push({id: id, event: 'untrashed'})
            end
          rescue Exception => e
          end
          objects
        end
        logger.post("tegu.api", log_data.merge({event: "conversations.#{params.label}", conversation_ids: ids.join(',')}))
        {conversations: objects}
      end

      desc "Create conversation"
      post 'to/:user_id' do
        authenticate!
        user_to = User.find(params.user_id)
        # create conversation
        receipt = current_user.send_message(user_to, params.message.body, params.message.subject)
        conversation = receipt.message.conversation
        if params.listing.present?
          begin
            # add listing to conversation
            listing = Listing.find(params.listing.id)
            object = ListingConversation.create!(conversation: conversation, listing: listing)
          rescue Exception => e
          end
        end
        # update user's inbox unread count
        user_to.update_attributes(inbox_unread_count: user_to.mailbox.inbox.unread(user_to).count)
        result = {receipt: receipt, to: {user_id: user_to.id, inbox_unread_count: user_to.inbox_unread_count}}
        result = result.merge(listing: {id: listing.try(:id)}) if listing.present?
        logger.post("tegu.api", log_data.merge({event: 'conversation.create'}))
        result
      end

      desc "Reply to conversation"
      post ':id/reply' do
        authenticate!
        conversation = Conversation.find(params.id)
        participants = conversation.participants
        receipt = current_user.reply_to_conversation(conversation, params.message.body)
        user_to = (participants - [current_user]).first
        # update user's inbox unread count
        user_to.update_attributes(inbox_unread_count: user_to.mailbox.inbox.unread(user_to).count)
        logger.post("tegu.api", log_data.merge({event: 'conversation.reply'}))
        {receipt: receipt, to: {user_id: user_to.id, inbox_unread_count: user_to.inbox_unread_count}}
      end
    end # conversations
  end
end