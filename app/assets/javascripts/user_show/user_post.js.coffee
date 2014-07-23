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

  # create commente
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
          if object_type == 'post'
            # create post comment
            Tegu.PostApi.create_comment(object_id, {comment: {body: body}}, auth_token, callback)
        (data, callback) ->
          console.log data
          # reload page
          window.location.reload(true)
      ]
