module Endpoints
  class PaymentApi < Grape::API
    format :json

    resource :payments do
      desc "Create payment, and return paypal pay link"
      post ':listing_id/shipping/to/:country_code' do
        authenticate!
        begin
          @listing = Listing.find(params.listing_id)
          @shipping_price = @listing.shipping_price(to: params.country_code)
          @payment = Payment.create!(listing: @listing, buyer: current_user, listing_price: @listing.price,
            shipping_price: @shipping_price, shipping_to: params.country_code)
          @payment.paypal_pay(
            cancel_url: "#{Settings[Rails.env][:api_root]}/payments/#{@payment.id}/paypal/cancel",
            return_url: "#{Settings[Rails.env][:api_root]}/payments/#{@payment.id}/paypal/success",
            ipn_notify_url: "#{Settings[Rails.env][:api_root]}/payments/#{@payment.id}/paypal/ipn_notify")
          # @payment.paypal_pay(
          #   cancel_url: Rails.application.routes.url_helpers.paypal_status_url(host: api_host, payment_id: @payment.id, status: 'cancel'),
          #   return_url: Rails.application.routes.url_helpers.paypal_status_url(host: api_host, payment_id: @payment.id, status: 'success'),
          #   ipn_notify_url: Rails.application.routes.url_helpers.paypal_ipn_notify_url(host: api_host, payment_id: @payment.id))
          logger.post("tegu.api", log_data.merge({event: 'payment.create', listing_id: @listing.id,
            payment_id: @payment.id, buyer_id: current_user.id}))
          {payment: {id: @payment.id, state: @payment.state, payment_url: @payment.payment_url}}
        rescue Exception => e
          logger.post("tegu.api", log_data.merge({event: 'payment.exception', exception: e.message}))
          {payment: {id: @payment.try(:id), exception: e.message}}
        end
      end

      desc "Payment paypal ipn notify callback"
      get ':id/paypal/ipn_notify' do
        @payment = Payment.find(params.id)
        logger.post("tegu.api", log_data.merge({event: "paypal.ipn_notify", payment_id: @payment.id}))
        {payment: {id: @payment.id}}
      end

      desc "Payment paypal status callback"
      get ':id/paypal/:status' do
        @payment = Payment.find(params.id)
        @listing = @payment.listing
        @seller = @listing.user
        @status = params.status

        if @status == 'cancel'
          @payment.cancel!
          @message = 'canceled'
        elsif @status == 'success'
          @payment.complete!
          @listing.sold!
          @message = 'sold'
        end

        logger.post("tegu.api", log_data.merge({event: "paypal.#{@status}", payment_id: @payment.id,
          listing_id: @listing.id, buyer_id: @payment.buyer_id}))

        # redirect
        @goto = Rails.application.routes.url_helpers.user_listing_path(@seller, @listing.id, message: @message)
        redirect @goto, permanent: true
      end

    end # payments
  end # paymentapi
end