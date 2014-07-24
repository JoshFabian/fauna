$(document).ready ->

  # toggle like
  $(document).on 'click', ".object-like", (e) ->
    e.preventDefault()
    object_id = $(this).data('object-id')
    object_id = $(this).data('object-id')
    object_klass = $(this).data('object-klass')
    console.log "#{object_klass}:#{object_id} like ..."
    async.waterfall [
      (callback) ->
        if object_klass == 'listing'
          # toggle listing like
          Tegu.ListingApi.toggle_like(object_id, auth_token, callback)
        else if object_klass == 'post'
          # toggle post like
          Tegu.PostApi.toggle_like(object_id, auth_token, callback)
      (data, callback) ->
        # get story
        Tegu.StoryView.get_story(object_id, object_klass, auth_token, callback)
      (data, callback) ->
        console.log "story replace #{object_klass}:#{object_id}"
        Tegu.StoryView.replace_story(object_klass, object_id, data)
    ]
