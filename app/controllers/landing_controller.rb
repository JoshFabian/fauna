class LandingController < ApplicationController

  # GET /landing
  # GET /landing/12345
  def index
    @code = params[:code]
  end

end