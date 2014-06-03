class Tegu.SmsApi
  @send_token: (to, token, callback = null) ->
    api = "/api/v1/sms/token/send?to=#{to}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @verify_token: (code, token, callback = null) ->
    api = "/api/v1/sms/token/verify?code=#{code}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback