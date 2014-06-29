class Tegu.PaymentApi
  @create_payment: (listing_id, shipping_to, token, callback = null) ->
    api = "/api/v1/payments/#{listing_id}/shipping/to/#{shipping_to}?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback
