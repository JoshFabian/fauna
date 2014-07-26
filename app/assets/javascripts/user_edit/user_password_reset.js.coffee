$(document).ready ->

  # user edit form
  $("form.user-reset-password").validate
    onsubmit: true,
    submitHandler: (form) ->
      console.log "password reset ..."
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
      
