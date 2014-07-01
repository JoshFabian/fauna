$(document).ready ->

  Tegu.cover_image_deletes = []

  $(".edit-hide .button, .edit-show .button").on 'click', (e) ->
    e.preventDefault()
    $("body").toggleClass('editing')
    button_name = $(this).text()
    if button_name.match(/save/i)
      # trigger form submit
      $("form.user-edit").submit()

  # user edit form
  $("form.user-edit").validate
    onsubmit: true,
    submitHandler: (form) ->
      $("form.user-edit #cover_image_deletes").val(Tegu.cover_image_deletes.join(","))
      form_data = $("form.user-edit").serialize()
      user_id = $("form.user-edit").data('user-id')
      # get cover image positions
      cover_images = []
      for object in $(".cover-photos .cover-photo")
        if $(object).data('image-id') != 0
          cover_images.push {id: $(object).data('image-id'), position: $(object).data('position')}
      console.log "cover images:#{JSON.stringify cover_images}"
      if user_id == 0
        console.log('creating user')
        # create user using default form submit
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
            # sort cover images
            Tegu.UserApi.sort_cover_images(user_id, {cover_images: cover_images}, auth_token, callback)
          (data, callback) ->
            console.log data
            # reload page
            window.location.reload(true)
        ],
        # optional callback
        (err, results) ->
          # console.log results[0]
          # jQuery.gritter.add({image: '/assets/success.png', title: 'User', text: 'Saved'})
