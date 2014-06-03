class MessagesController < ApplicationController

  def index

    respond_to do |format|
      format.html { render(template: "messages/_index") }
    end
  end

end
