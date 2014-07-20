class PaymentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:index]

  # GET /payments
  def index
    @payments = Payment.order("id desc")

    @title = "Manage Payments | Admin"
  end

end