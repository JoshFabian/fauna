class ReviewsController < ApplicationController

  before_filter :authenticate_user!

  # GET /reviews
  def index
    
  end

  # GET /reviews/new
  def new
    @listing = Listing.first
    @user = @listing.user

    @reviewed = @listing.reviews.where(user_id: current_user.id).exists?
  end

end