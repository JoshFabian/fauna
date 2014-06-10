class ReviewsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:new]

  # GET /reviews
  def index
    
  end

  # GET /:handle/listings/:id/reviews/new
  def new
    @user = User.find_by_handle(params[:handle])
    @listing = @user.listings.friendly.find(params[:id])

    @reviewed = @listing.reviews.where(user_id: current_user.id).exists?
  end

end