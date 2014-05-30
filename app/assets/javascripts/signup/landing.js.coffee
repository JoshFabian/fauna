class Tegu.Landing
  @goto_step_2: () ->
    $(".user-email-form-wrapper").hide()
    $(".user-role-form-wrapper").show()

  @goto_step_3_original: (waitlist) ->
    $(".user-email-form-wrapper").hide()
    $(".user-role-form-wrapper").hide()
    $(".user-invite-friends-form-wrapper .signup-count").html(waitlist.signup_count)
    $(".user-invite-friends-form-wrapper .invite-code input").val(waitlist.share_url)
    $(".user-invite-friends-form-wrapper").show()
    $(".landing-form").addClass('hide')

  @goto_step_3: (waitlist) ->
    # redirect to success landing
    window.location.href = "/landing/success/#{waitlist.code}"

$(document).ready ->

  waitlist_id = 0

  # user email form

  $(".email-form-button").on 'click', (event) ->
    event.preventDefault()
    $(".user-email-form").submit()

  $(".user-email-form").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $(".user-email-form").serialize()
      form_email = $(".user-email-form input.email").val()
      async.waterfall [
        (callback) ->
          # check email
          console.log "checking email:#{form_email}"
          Tegu.WaitlistApi.check(form_email, auth_token, callback)
        (data, callback) ->
          console.log data
          if data.waitlist
            waitlist_id = data.waitlist.id
            Tegu.Landing.goto_step_3(data.waitlist)
          else
            # create
            Tegu.WaitlistApi.create(form_data, auth_token, callback)
        (data, callback) ->
          # console.log data
          waitlist_id = data.waitlist.id
          Tegu.Landing.goto_step_2()
      ]

  # user role form

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
          # console.log data
          Tegu.Landing.goto_step_3(data.waitlist)
      ]

