class Tegu.ListingApi
  @get_show_route: (listing_id, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/show/route?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @create: (params, token, callback = null) ->
    api = "/api/v1/listings/?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @create_review: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/reviews?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @delete_image: (listing_id, image_id, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/images/#{image_id}?token=#{token}"
    $.ajax api,
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @put_event: (id, event, token, callback = null) ->
    api = "/api/v1/listings/#{id}/event/#{event}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @update: (id, params, token, callback = null) ->
    api = "/api/v1/listings/#{id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

