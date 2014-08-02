$(document).ready ->

  # share object
  $(document).on 'click', ".object-facebook-share", (e) ->
    e.preventDefault()
    object_klass = $(this).data('object-klass')
    object_id = $(this).data('object-id')
    facebook_permission = $(this).data('facebook-permission')
    if facebook_permission == 'basic'
      console.log "#{object_klass}:#{object_id} share auth ..."
      window.location.href = Tegu.FacebookShareRoute.auth_route(object_klass, object_id, 'story')
      return
    console.log "#{object_klass}:#{object_id} share ..."
    async.waterfall [
      (callback) ->
        if object_klass == 'listing'
          # share listing
          Tegu.ListingApi.share_facebook(object_id, auth_token, callback)
        else if object_klass == 'post'
          # share post
          Tegu.PostApi.share_facebook(object_id, auth_token, callback)
      (data, callback) ->
        try
          console.log data
          if data.event == 'share'
            console.log "shared"
        catch e
    ]