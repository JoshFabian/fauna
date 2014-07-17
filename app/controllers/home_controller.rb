class HomeController < ApplicationController

  # GET /
  def index
    redirect_to recent_listings_path
  end

  # GET /:slug/exception
  def exception
    raise Exception, "exception"
  end
end