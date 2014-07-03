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
      user_handle = $(form).data('user-handle')
      console.log "verifying email:#{email}"
      async.waterfall [
        (callback) ->
          # send token
          Tegu.UserVerifyEmail.hide_error_state()
          Tegu.PaypalApi.verify_email(email, auth_token, callback)
        (data, callback) ->
          console.log data
          if data.event == 'verified'
            # redirect
            Tegu.UserVerify.goto_user_verify(user_handle)
          else
            # show error state
            Tegu.UserVerifyEmail.show_error_state()
      ],
      # optional callback
      (err, results) ->