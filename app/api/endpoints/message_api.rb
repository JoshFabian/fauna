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
    end
  end
end