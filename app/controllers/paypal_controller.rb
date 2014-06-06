class PaypalController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!, only: [:start, :status]

  # GET /paypal/pay/:listing_id/start
  def start
    @listing = Listing.find(params[:listing_id])
    @payment = Payment.create(listing: @listing, buyer: current_user)
    @payment.paypal_pay(
      cancel_url: paypal_status_url(payment_id: @payment.id, status: 'cancel'),
      return_url: paypal_status_url(payment_id: @payment.id, status: 'success'),
      ipn_notify_url: paypal_ipn_notify_url(payment_id: @payment.id))
    logger.post("tegu.app", log_data.merge({event: 'paypal.pay.start', payment_id: @payment.id, listing_id: @listing.id,
      buyer_id: current_user.id}))
    redirect_to @payment.payment_url and return
  rescue Exception => e
    raise
  end

  # GET /paypal/pay/:payment_id/:status
  def status
    @payment = Payment.find(params[:payment_id])
    @listing = @payment.listing

    if params[:status] == 'cancel'
      @payment.cancel!
    elsif params[:status] == 'success'
      @payment.complete!
    end

    logger.post("tegu.app", log_data.merge({event: "paypal.pay.#{params[:status]}", payment_id: @payment.id,
      listing_id: @listing.id}))
  end

  # POST /paypal/pay/:payment_id/ipn_notify
  def ipn_notify
    @payment = Payment.find(params[:payment_id])

    logger.post("tegu.app", log_data.merge({event: "paypal.pay.ipn_notify", payment_id: @payment.id, params: params}))

    return head(:ok)
  end
end