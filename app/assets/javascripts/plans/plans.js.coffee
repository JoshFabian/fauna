class Tegu.Plan
  @_stripe_handler = 0

  @init_stripe_handler: () ->
    if @_stripe_handler == 0
      console.log "init stripe handler"
      @_stripe_handler = StripeCheckout.configure
        key: stripe_publish_key,
        image: stripe_image,
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

  @open_stripe_handler: (amount, description) ->
    @_stripe_handler.open({allowRememberMe: false, amount: amount, name: 'Fauna', description: description})

  @unmark_credit_plans: () ->
    $(".plan-credits input:radio").attr('checked', false)

  @unmark_subscription_plans: () ->
    $(".plan-subscriptions input:radio").attr('checked', false)

  @get_details: (plan_id, token, callback) ->
    $.ajax "/plans/#{plan_id}/details?token=#{token}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

$(document).ready ->

  # try
  #   plan_id = 0
  #   plan_amount = 0
  #   plan_subscription = false
  #   plan_image = nil
  #   # stripe_handler = nil
  #   if false#stripe_payment == 1
  #     console.log "init stripe handler"
  #     stripe_handler = StripeCheckout.configure
  #       key: stripe_publish_key,
  #       image; plan_image,
  #       token: (token, args) ->
  #         console.log "token:#{JSON.stringify token}, args:#{JSON.stringify args}"
  #         card_token = token.id
  #         async.waterfall [
  #           (callback) ->
  #             if plan_subscription
  #               # subscribe to plan
  #               Tegu.StripeApi.subscribe(plan_id, card_token, auth_token, callback)
  #             else
  #               # buy credits with token
  #               Tegu.StripeApi.buy_credits(plan_id, card_token, auth_token, callback)
  #           (data, callback) ->
  #             console.log data
  #             if data.event == 'buy' or data.event == 'subscribe'
  #               console.log data.event
  #         ],
  #         # optional callback
  #         (err, results) ->
  # catch e

  $(".plan-credits").on 'click', (e) ->
    Tegu.Plan.unmark_subscription_plans()

  $(".plan-subscriptions").on 'click', (e) ->
    Tegu.Plan.unmark_credit_plans()
    input = $(this).closest('form').find("input[type='radio']:checked")
    plan_id = $(input).data('plan-id')
    console.log "plan:#{plan_id} details ..."
    async.waterfall [
      (callback) ->
        Tegu.Plan.get_details(plan_id, auth_token, callback)
      (data, callback) ->
        console.log data
        $(".pro-details").html(data)
    ]

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
      Tegu.Plan.init_stripe_handler()
      Tegu.Plan.open_stripe_handler(plan_amount, plan_name)


 