class Tegu.StripeApi
  @buy_credits: (plan_id, card_token, token, callback = null) ->
    api = "/api/v1/stripe/buy/credits/#{plan_id}?card_token=#{card_token}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @subscribe: (plan_id, card_token, token, callback = null) ->
    api = "/api/v1/stripe/subscribe/#{plan_id}?card_token=#{card_token}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback