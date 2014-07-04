class HomeController < ApplicationController

  # GET /
  def index
  end

  # GET /exception
  def exception
    raise Exception, "exception"
  end
end