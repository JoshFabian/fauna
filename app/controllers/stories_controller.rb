class StoriesController < ApplicationController

  # GET /stories/:id?klass=post
  def show
    @story = Hashie::Mash.new(id: params[:id], type: params[:klass])
    @klass = @story.type.titleize.constantize
    @object = @klass.find(@story.id)

    respond_to do |format|
      format.js
    end
  end
  
end