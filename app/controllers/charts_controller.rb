class ChartsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!

  # GET /charts/user_signups
  def user_signups

  end

end