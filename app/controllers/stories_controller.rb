class StoriesController < ApplicationController

  # GET /stories?id=1
  def index
    @user = User.find(params[:id])
    @stories = Story.by_wall(@user).page(page).per(per) rescue []

    respond_to do |format|
      format.js
    end
  end

  # GET /stories/:id?klass=post
  def show
    @story = Hashie::Mash.new(id: params[:id], type: params[:klass])
    @klass = @story.type.titleize.constantize
    @object = @klass.find(@story.id)

    respond_to do |format|
      format.js
    end
  end

  protected

  def page
    params[:page]
  end

  def per
    20
  end

end