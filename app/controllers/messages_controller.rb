class MessagesController < ApplicationController

  # GET /:handle/messages/:label
  def index
    @user = current_user
    @label = params[:label]
    @conversations = @user.mailbox.send(@label).limit(10)

    respond_to do |format|
      format.js
    end
  end

  # GET /:handle/messages/:id
  def show
    @user = current_user
    @conversation = Conversation.find(params[:id])
    @receipts = @conversation.receipts_for(current_user)
    @participants = @conversation.participants
    @listing = ListingConversation.where(conversation_id: @conversation.id).first.try(:listing)

    respond_to do |format|
      format.js
    end
  end
end
