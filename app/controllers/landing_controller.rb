class LandingController < ApplicationController

  # GET /landing
  # GET /landing/:code
  def index
    @code = params[:code]
  end

  # GET /landing/success/:code
  def success
    @waitlist = Waitlist.find_by_code(params[:code])

    respond_to do |format|
      format.html
    end
  end
end