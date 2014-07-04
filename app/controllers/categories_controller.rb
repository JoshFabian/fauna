class CategoriesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:index]

  # GET /categories
  def index
    @categories = Category.order('level asc, name asc')
  end

end