class PaypalController < ApplicationController

  before_filter :authenticate_user!, only: [:start, :status]

  # GET /paypal/pay/start
  def start
    @listing = Listing.find(params[:listing_id])
    @payment = Payment.create(listing: @listing, buyer: current_user)
    @payment.start(
      buyer_email: "buyer@fauna.net", #current_user.email,
      cancel_url: paypal_status_url(payment_id: @payment.id, status: 'cancel'),
      return_url: paypal_status_url(payment_id: @payment.id, status: 'success'),
      ipn_notify_url: paypal_status_url(payment_id: @payment.id, status: 'ipn_notify'))
    redirect_to @payment.payment_url and return
  rescue Exception => e
    raise
  end

  # GET /paypal/pay/:payment_id/:status?payment_id=1
  # GET /paypal/pay/cancel|success|ipn_notify?payment_id=1
  def status
    @payment = Payment.find(params[:payment_id])

    if params[:status] == 'cancel'
      @payment.cancel!
    elsif params[:status] == 'success'
      @payment.complete!
    elsif params[:status] == 'ipn_notify'
      # todo: capture ipn info
    end

  end

end