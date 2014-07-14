class Tegu.PaypalApi
  @verify_email: (email, first_name, last_name, token, callback = null) ->
    api = "/api/v1/paypal/verify/email?email=#{email}&first_name=#{first_name}&last_name=#{last_name}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback