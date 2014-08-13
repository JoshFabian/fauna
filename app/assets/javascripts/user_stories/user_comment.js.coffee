$(document).ready ->

  # show comment
  $(document).on 'click', '.object-comment', (e) ->
    e.preventDefault()
    # show related comment section
    $(this).closest(".panel-footer").siblings(".comment-section").removeClass('hide')

  # create comment
  $(document).on 'keypress', '.comment-section .status-form', (e) ->
    if (e.which == 13)
      body = $(this).val()
      return if !body or $(this).hasClass('disabled')
      if current_user == 0
        return window.location.href = Tegu.GuestRoute.login_route()
      $(this).addClass('disabled')
      object_id = $(this).data('object-id')
      object_klass = $(this).data('object-klass')
      console.log "#{object_klass}:#{object_id} comment ..."
      async.waterfall [
        (callback) ->
          if object_klass == 'listing'
            # create listing comment
            Tegu.ListingApi.create_comment(object_id, {comment: {body: body}}, auth_token, callback)
          else if object_klass == 'post'
            # create post comment
            Tegu.PostApi.create_comment(object_id, {comment: {body: body}}, auth_token, callback)
        (data, callback) ->
          # get story
          Tegu.StoryView.get_story(object_id, object_klass, auth_token, callback)
        (data, callback) ->
          console.log "story replace #{object_klass}:#{object_id}"
          Tegu.StoryView.replace_story(object_klass, object_id, data)
      ]
