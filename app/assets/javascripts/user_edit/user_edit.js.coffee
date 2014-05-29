$(document).ready ->

  $(".edit-hide .button, .edit-show .button").on 'click', (e) ->
    e.preventDefault()
    $("body").toggleClass('editing')
    user_id = $(this).data('user-id')
    button_name = $(this).text()
    if button_name.match(/save/i)
      $("form.user-edit").submit()

  # user edit form
  $("form.user-edit").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $("form.user-edit").serialize()
      # avatar_params = $("form.user-edit input.avatar-params").val()
      user_id = $("form.user-edit").data('user-id')
      if user_id == 0
        console.log('creating user')
        # creat user using default form submit
        form.submit()
      else
        # update user
        console.log("user:#{user_id} ... saving")
        async.waterfall [
          (callback) ->
            # update user
            Tegu.UserApi.update(user_id, form_data, auth_token, callback)
          (data, callback) ->
            console.log data
            # update user fields
        ],
        # optional callback
        (err, results) ->
          # console.log results[0]
          # jQuery.gritter.add({image: '/assets/success.png', title: 'User', text: 'Saved'})
