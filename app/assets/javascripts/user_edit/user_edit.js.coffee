$(document).ready ->

  Tegu.cover_image_deletes = []

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
      $("form.user-edit #cover_image_deletes").val(Tegu.cover_image_deletes.join(","))
      form_data = $("form.user-edit").serialize()
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
            # reload page
            window.location.reload(true)
        ],
        # optional callback
        (err, results) ->
          # console.log results[0]
          # jQuery.gritter.add({image: '/assets/success.png', title: 'User', text: 'Saved'})
