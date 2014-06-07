class Tegu.PaypalApi
  @verify_email: (email, token, callback = null) ->
    api = "/api/v1/paypal/verify/email?email=#{email}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback