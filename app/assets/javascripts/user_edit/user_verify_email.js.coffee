$(document).ready ->

  # verify email form
  $("form.user-verify-email").validate
    onsubmit: true,
    submitHandler: (form) ->
      email = $(form).find("input.email").val()
      user_handle = $(form).data('user-handle')
      console.log "verifying email:#{email}"
      async.waterfall [
        (callback) ->
          # send token
          Tegu.PaypalApi.verify_email(email, auth_token, callback)
        (data, callback) ->
          console.log data
          if data.event == 'verified'
            window.location.href = "/#{user_handle}/verify"
      ],
      # optional callback
      (err, results) ->