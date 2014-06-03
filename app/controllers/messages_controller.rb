class MessagesController < ApplicationController

  def index

    respond_to do |format|
      format.html { render(template: "messages/_index") }
    end
  end

  # GET /:handle/messages/1
  def show

  end
end
