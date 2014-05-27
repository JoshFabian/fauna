class WaitlistsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:index]

  # GET /waitlists
  def index
    @waitlists = Waitlist.all
    @total_count = Waitlist.count
    @both_count = Waitlist.both.count
    @buyers_count = Waitlist.buyer.count
    @sellers_count = Waitlist.seller.count
  end

end