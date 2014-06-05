module Endpoints
  class StripeApi < Grape::API
    format :json

    resource :stripe do
      desc "Buy credits with stripe token"
      put 'buy/credits/:plan_id' do
        begin
          authenticate!
          plan = Plan.find(params[:plan_id])
          # charge card
          charge = Stripe::Charge.create(amount: plan.amount, card: params.card_token, currency: 'usd')
          # add listing credits
          current_user.increment(:listing_credits, plan.credits)
          current_user.save
          event = 'buy'
          logger.post("tegu.api", log_data.merge({event: 'stripe.buy.credits', plan_id: plan.id}))
        rescue Stripe::CardError => e
          # charge error
          event = 'error'
          message = e.message
        rescue Exception => e
          # other error
          event = 'error'
          message = e.message
        end
        {event: event, message: message, user: current_user.as_json(only: [:id, :listing_credits])}
      end

      desc "Subscribe user to the specified plan"
      put 'subscribe/:plan_id' do
        authenticate!
        begin
          plan = Plan.find(params[:plan_id])
          customer = Customer.find_or_create(current_user)
          # create stripe subscription
          object = customer.subscriptions.create(plan: plan.stripe_id, card: params.card_token)
          # filter stripe object
          object = object.to_hash.select{ |k,v| [:id].include?(k) }
          subscription = current_user.subscriptions.create(plan: plan, stripe: object)
          event = 'subscribe'
          logger.post("tegu.api", log_data.merge({event: 'stripe.subscribe', plan_id: plan.id}))
        rescue Exception => e
          # other error
          event = 'error'
          message = e.message
        end
        {event: event, message: message, user: current_user.as_json(only: [:id]).merge(
          subscription: subscription.as_json())}
      end

      desc "Unsubscribe user to the specified plan"
      put 'unsubscribe/:plan_id' do
        authenticate!
        begin
          # find plan and subscription
          plan = Plan.find(params[:plan_id])
          subscription = current_user.subscriptions.where(plan_id: plan.id).first
          raise Exception, "invalid subscription" if subscription.blank?
          # remove stripe subscription
          customer = Customer.find_or_create(current_user)
          customer.subscriptions.retrieve(subscription.stripe_id).delete()
          # remove subscription object
          subscription.destroy()
          event = 'unsubscribe'
        rescue Exception => e
          # other error
          event = 'error'
          message = e.message
        end
        {event: event, message: message, user: current_user.as_json(only: [:id]).merge(
          subscription: subscription.as_json())}
      end
    end # stripe
  end
end