$(document).ready ->

  # toggle like
  $(document).on 'click', ".object-facebook-share", (e) ->
    e.preventDefault()
    object_id = $(this).data('object-id')
    object_klass = $(this).data('object-klass')
    console.log "#{object_klass}:#{object_id} share ..."
    async.waterfall [
      (callback) ->
        if object_klass == 'listing'
          # toggle listing like
          Tegu.ListingApi.share_facebook(object_id, auth_token, callback)
        else if object_klass == 'post'
          # toggle post like
          Tegu.PostApi.share_facebook(object_id, auth_token, callback)
      (data, callback) ->
        console.log data
    ]