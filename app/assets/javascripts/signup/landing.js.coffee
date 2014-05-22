class Tegu.Landing
  @goto_step_2: () ->
    $(".user-email-form-wrapper").hide()
    $(".user-role-form-wrapper").show()

  @goto_step_3: (signup_count, invite_code) ->
    $(".user-email-form-wrapper").hide()
    $(".user-role-form-wrapper").hide()
    $(".user-invite-friends-form-wrapper .signup-count").html(signup_count)
    $(".user-invite-friends-form-wrapper").show()

$(document).ready ->

  waitlist_id = 0

  $(".email-form-button").on 'click', (event) ->
    event.preventDefault()
    $(".user-email-form").submit()

  $(".user-email-form").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $(".user-email-form").serialize()
      async.waterfall [
        (callback) ->
          # create
          Tegu.WaitlistApi.create(form_data, auth_token, callback)
        (data, callback) ->
          console.log data
          waitlist_id = data.waitlist.id
          Tegu.Landing.goto_step_2()
      ]

  $(".user-role-form-submit").on 'click', (event) ->
    event.preventDefault()
    $(".user-role-form").submit()

  $(".user-role-form").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $(".user-role-form").serialize()
      async.waterfall [
        (callback) ->
          # update
          Tegu.WaitlistApi.update(waitlist_id, form_data, auth_token, callback)
        (data, callback) ->
          console.log data
          Tegu.Landing.goto_step_3(data.waitlist.signup_count, data.waitlist.code)
      ]

