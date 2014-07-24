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
