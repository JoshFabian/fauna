$(document).ready ->

  # create post
  $(document).on 'click', '.status-panel .status-button', (e) ->
    e.preventDefault()
    body = $(".status-panel .status-form").val()
    return if !body or $(this).hasClass('disabled')
    $(this).addClass('disabled')
    console.log "post create ..."
    async.waterfall [
      (callback) ->
        # create post
        Tegu.PostApi.create({post: {body: body}}, auth_token, callback)
      (data, callback) ->
        # get story
        Tegu.StoryView.get_story(data.post.id, 'post', auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.StoryView.prepend_story(data)
    ]
