class ReviewsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:index]

  # GET /reviews
  def index
    
  end

  # GET /:slug/listings/:id/reviews/new
  def new
    @user = User.by_slug(params[:slug])
    @listing = @user.listings.friendly.find(params[:id])

    @reviewed = @listing.reviews.where(user_id: current_user.id).exists?
  end

end