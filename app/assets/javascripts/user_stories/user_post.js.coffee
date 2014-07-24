$(document).ready ->

  # create post
  $(".status-panel .status-button").on 'click', (e) ->
    e.preventDefault()
    body = $(".status-panel .status-form").val()
    return if !body or $(this).hasClass('disabled')
    $(this).addClass('disabled')
    console.log "user:#{current_user} post ..."
    async.waterfall [
      (callback) ->
        # create post
        Tegu.PostApi.create({post: {body: body}}, auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]

  # show comment
  $(".object-comment").on 'click', (e) ->
    e.preventDefault()
    # show related comment section
    $(this).closest(".panel-footer").siblings(".comment-section").removeClass('hide')

  # create comment
  $(".comment-section .status-form").keypress (e) ->
    if (e.which == 13)
      body = $(this).val()
      return if !body or $(this).hasClass('disabled')
      $(this).addClass('disabled')
      object_id = $(this).data('object-id')
      object_type = $(this).data('object-type')
      console.log "user:#{current_user} #{object_type} comment ..."
      async.waterfall [
        (callback) ->
          if object_type == 'listing'
            # create listing comment
            Tegu.ListingApi.create_comment(object_id, {comment: {body: body}}, auth_token, callback)
          else if object_type == 'post'
            # create post comment
            Tegu.PostApi.create_comment(object_id, {comment: {body: body}}, auth_token, callback)
        (data, callback) ->
          console.log data
          # reload page
          window.location.reload(true)
      ]