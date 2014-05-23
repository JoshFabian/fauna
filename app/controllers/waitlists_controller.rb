class WaitlistsController < ApplicationController

  before_filter :authenticate_user!
  # before_filter :admin_role_required!, only: [:index]

  # GET /waitlists
  def index
    @waitlists = Waitlist.all
  end

end