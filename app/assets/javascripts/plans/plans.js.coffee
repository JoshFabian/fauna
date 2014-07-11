class Tegu.Plan
  @unmark_credit_plans: () ->
    $(".plan-credits input:radio").attr('checked', false)

  @unmark_subscription_plans: () ->
    $(".plan-subscriptions input:radio").attr('checked', false)

$(document).ready ->

  try
    plan_id = 0
    plan_amount = 0
    plan_subscription = false
    if stripe_payment == 1
      stripe_handler = StripeCheckout.configure
        key: stripe_publish_key,
        token: (token, args) ->
          console.log "token:#{JSON.stringify token}, args:#{JSON.stringify args}"
          card_token = token.id
          async.waterfall [
            (callback) ->
              if plan_subscription
                # subscribe to plan
                Tegu.StripeApi.subscribe(plan_id, card_token, auth_token, callback)
              else
                # buy credits with token
                Tegu.StripeApi.buy_credits(plan_id, card_token, auth_token, callback)
            (data, callback) ->
              console.log data
              if data.event == 'buy' or data.event == 'subscribe'
                console.log data.event
          ],
          # optional callback
          (err, results) ->
  catch e

  $(".plan-credits").on 'click', (e) ->
    Tegu.Plan.unmark_subscription_plans()

  $(".plan-subscriptions").on 'click', (e) ->
    Tegu.Plan.unmark_credit_plans()

  $(".plan-submit").on 'click', (e) ->
    e.preventDefault()
    form = $(this).closest('form')
    input = $(form).find("input[type='radio']:checked")
    plan_id = $(input).data('plan-id')
    plan_amount = $(input).data('plan-amount')
    plan_name = $(input).data('plan-name')
    plan_subscription = $(input).data('plan-subscription')
    console.log "stripe plan:#{plan_id}:#{plan_name}:subscription:#{plan_subscription} for #{plan_amount}"
    if plan_id
      # call stripe handler to charge card and return token
      stripe_handler.open({allowRememberMe: false, amount: plan_amount, name: 'Fauna', description: plan_name})

 