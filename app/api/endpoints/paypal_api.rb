module Endpoints
  class PaypalApi < Grape::API
    format :json

    resource :paypal do
      desc "Verify email address"
      put 'verify/email' do
        begin
          authenticate!
          api = PayPal::SDK::AdaptiveAccounts::API.new
          data = api.build_get_verified_status({emailAddress: params.email, matchCriteria: "NONE"})
          response = api.get_verified_status(data)
          raise Exception, "error" if !response.success?
          current_user.update_attributes(paypal_email: params.email)
          event = 'verified'
        rescue Exception => e
          event = 'error'
        end
        {event: event, user: current_user.as_json(only: [:id, :paypal_email])}
      end

    end
  end
end