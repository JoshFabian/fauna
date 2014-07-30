$(document).ready ->

  # toggle like
  $(document).on 'click', ".object-facebook-share", (e) ->
    e.preventDefault()
    if $(this).hasClass('no-permissions')
      window.location.href = "/auth/facebook"
      return
    object_id = $(this).data('object-id')
    object_klass = $(this).data('object-klass')
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