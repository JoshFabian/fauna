class ListingReportsController < ApplicationController

  before_filter :authenticate_user!, only: [:new]
  before_filter :admin_role_required!, only: [:become, :index]

  # GET /listing_reports
  def index
    @reports = ListingReport.order("id desc")
  end
end