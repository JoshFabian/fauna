$(document).ready ->

  # create post
  $(document).on 'click', '.status-panel .status-button', (e) ->
    e.preventDefault()
    body = $(".status-panel .status-form").val()
    facebook_share = +$(".status-panel #post_facebook_share").prop('checked')
    facebook_share or= 0
    post_id = 0
    return if !body or $(this).hasClass('disabled')
    $(this).addClass('disabled')
    console.log "post create with share:#{facebook_share} ..."
    async.waterfall [
      (callback) ->
        # create post
        Tegu.PostApi.create({post: {body: body, facebook_share: facebook_share}}, auth_token, callback)
      (data, callback) ->
        post_id = data.post.id
        # get story
        Tegu.StoryView.get_story(data.post.id, 'post', auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.StoryView.prepend_story(data)
        # check facebook share auth
        Tegu.PostApi.get_facebook_share_auth(post_id, auth_token, callback)
      (data, callback) ->
        console.log data
        if data.auth == 1
          # facebook auth
          window.location.href = Tegu.FacebookShareRoute.auth_route('post', post_id, 'story')
    ]
