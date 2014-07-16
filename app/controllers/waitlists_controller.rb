class WaitlistsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:index]

  # GET /waitlists
  def index
    @waitlists = Waitlist.order("id desc").page(params[:page]).per(20)
    @total_count = Waitlist.count
    @both_count = Waitlist.both.count
    @buyers_count = Waitlist.buyer.count
    @sellers_count = Waitlist.seller.count

    respond_to do |format|
      format.html { render(layout: !request.xhr?) }
    end
  end

end