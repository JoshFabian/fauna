class StoriesController < ApplicationController

  helper_method :page

  # GET /stories?id=1&page=1
  def index
    @user = User.find(params[:id])
    @stories = Story.by_wall(@user).page(page).per(per)

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
    10
  end

end