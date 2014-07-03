class PaypalController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!, only: [:start, :status]

  # deprecated
  # GET /paypal/pay/:payment_id/:status
  def status
    @payment = Payment.find(params[:payment_id])
    @listing = @payment.listing
    @seller = @listing.user
    @status = params[:status]

    logger.post("tegu.app", log_data.merge({event: "paypal.pay.#{@status}", payment_id: @payment.id,
      listing_id: @listing.id, buyer_id: @payment.buyer_id}))

    if @status == 'cancel'
      @payment.cancel!
      @goto = user_listing_path(@seller, @listing, status: 'canceled')
    elsif @status == 'success'
      @payment.complete!
      @listing.sold!
      @goto = user_listing_path(@seller, @listing, status: 'sold')
    end

    redirect_to @goto and return if @goto.present?
  end

  # deprecated
  # POST /paypal/pay/:payment_id/ipn_notify
  def ipn_notify
    @payment = Payment.find(params[:payment_id])

    logger.post("tegu.app", log_data.merge({event: "paypal.pay.ipn_notify", payment_id: @payment.id, params: params}))

    return head(:ok)
  end
end