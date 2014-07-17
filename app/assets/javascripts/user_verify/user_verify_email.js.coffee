class Tegu.UserVerifyEmail
  @hide_error_state: () ->
    $(".error-state").removeClass('active')

  @show_error_state: () ->
    $(".error-state").addClass('active')

$(document).ready ->

  # verify email form
  $("form.user-verify-email").validate
    onsubmit: true,
    submitHandler: (form) ->
      email = $(form).find("input.email").val()
      first_name = $(form).find("input.first-name").val()
      last_name = $(form).find("input.last-name").val()
      console.log "verifying #{email}:#{first_name}:#{last_name}"
      async.waterfall [
        (callback) ->
          # send token
          Tegu.UserVerifyEmail.hide_error_state()
          Tegu.PaypalApi.verify_email(email, first_name, last_name, auth_token, callback)
        (data, callback) ->
          console.log data
          if data.event == 'verified'
            # redirect
            window.location.href = Tegu.UserRoute.user_slug_route(current_user_slug, 'verify')
          else
            # show error state
            Tegu.UserVerifyEmail.show_error_state()
      ],
      # optional callback
      (err, results) ->