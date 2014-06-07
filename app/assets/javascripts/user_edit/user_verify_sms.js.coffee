$(document).ready ->

  # send sms form
  $("form.user-sms-send").validate
    onsubmit: true,
    submitHandler: (form) ->
      user_to = $(form).find("#user_to").val()
      console.log "sending sms token to: #{user_to}"
      async.waterfall [
        (callback) ->
          # send token
          Tegu.SmsApi.send_token(user_to, auth_token, callback)
        (data, callback) ->
          if data.event == 'sent'
            window.location.href = "/sms/verify_phone"
      ],
      # optional callback
      (err, results) ->

  # verify sms form
  $("form.user-sms-verify").validate
    onsubmit: true,
    submitHandler: (form) ->
      sms_code = $(form).find("#sms_code").val()
      user_handle = $(form).data('user-handle')
      console.log "verifying sms code: #{sms_code}"
      async.waterfall [
        (callback) ->
          # verify token
          Tegu.SmsApi.verify_token(sms_code, auth_token, callback)
        (data, callback) ->
          if data.event == 'verified'
            window.location.href = "/#{user_handle}/verify"
      ],
      # optional callback
      (err, results) ->
