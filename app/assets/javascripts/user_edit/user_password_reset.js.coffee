$(document).ready ->

  # user send reset password form
  $("form.user-send-reset-password").validate
    onsubmit: true,
    submitHandler: (form) ->
      email = $(form).find("input#user_email").val()
      console.log "send reset password ..."
      async.waterfall [
        (callback) ->
          # reset password
          Tegu.UserApi.send_reset_password(email, auth_token, callback)
        (data, callback) ->
          # console.log data
          try
            if data.user.id > 0
              console.log "password reset ok"
              $(".alert-box").addClass('success').removeClass('hide warning').text("You should get an email with instructions in a few minutes")
          catch e
            console.log "password reset error"
            $(".alert-box").addClass('warning').removeClass('hide success').text("Whoops, are you sure that's your email")
      ]

  # user reset password form
  $("form.user-reset-password").validate
    onsubmit: true,
    submitHandler: (form) ->
      console.log "reset password ..."
      form_data = $("form.user-reset-password").serialize()
      async.waterfall [
        (callback) ->
          # reset password
          Tegu.UserApi.reset_password(form_data, auth_token, callback)
        (data, callback) ->
          console.log data
          if data.user.id > 0
            window.location.href = Tegu.GuestRoute.login_route()
          else
            console.log "password reset error"
      ]
      
