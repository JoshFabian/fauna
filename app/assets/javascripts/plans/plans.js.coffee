$(document).ready ->

  try
    if stripe_payment == 1
      plan_id = 0
      amount = 0
      subscription = false
      stripe_handler = StripeCheckout.configure
        key: stripe_publish_key,
        token: (token, args) ->
          console.log "token:#{JSON.stringify token}, args:#{JSON.stringify args}"
          card_token = token.id
          async.waterfall [
            (callback) ->
              if subscription
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

  $(".plan-submit").on 'click', (e) ->
    e.preventDefault()
    form = $(this).closest('form')
    input = $(form).find("input[type='radio']:checked")
    plan_id = $(input).data('plan-id')
    amount = $(input).data('amount')
    subscription = $(input).data('subscription')
    console.log "stripe plan:#{plan_id}:subscribe:#{subscription} for #{amount}"
    if plan_id
      # call stripe handler to charge card and return token
      stripe_handler.open({allowRememberMe: false, amount: amount, name: 'Fauna', description: 'Buy Credits'})

 