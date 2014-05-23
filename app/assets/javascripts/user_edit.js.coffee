$(document).ready ->

  # user edit form
  $("form.user-edit").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $("form.user-edit").serialize()
      user_id = $("form.user-edit").data('user-id')
      if user_id == 0
        console.log('creating user')
        # creat user using default form submit
        form.submit()
      else
        # update user
        console.log("updating user: #{user_id}")
        async.series([
          (callback) ->
            # update list
            Slate.UserApi.update(user_id, form_data, auth_token, callback)
        ],
        # optional callback
        (err, results) ->
          # console.log results[0]
          jQuery.gritter.add({image: '/assets/success.png', title: 'User', text: 'Saved'})
        )