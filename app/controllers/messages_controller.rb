class MessagesController < ApplicationController

  # GET /:handle/messages/:label
  def index
    @user = current_user
    @label = params[:label]

    respond_to do |format|
      format.html { render(template: "messages/_index") }
    end
  end

  # GET /:handle/messages/labels?current=inbox
  # def labels
  #   @current_label = params[:current]
  # 
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # GET /:handle/messages/:label
  # def label
  #   @label = params[:label]
  # 
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # GET /:handle/messages/:label/:id
  def show
    @user = current_user
    @label = params[:label]
    @conversation = Conversation.find(params[:id])
    @receipts = @conversation.receipts_for(current_user)
    @participants = @conversation.participants
    @listing = Listing.first

    respond_to do |format|
      format.js
    end
  end
end
