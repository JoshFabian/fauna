class Tegu.ListingApi
  @get: (listing_id, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}?token=#{token}"
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

  @create_images: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/images?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @create_comment: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/comments?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @toggle_like: (listing_id, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/toggle_like?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
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

  @flag: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/flag?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params
      success: (data) ->
        callback(null, data) if callback

  @put_event: (listing_id, event, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/event/#{event}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @update: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @update_images: (listing_id, params, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/images?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @get_shipping_price: (listing_id, country_code, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/shipping/to/#{country_code}?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @share_facebook: (listing_id, token, callback = null) ->
    api = "/api/v1/listings/#{listing_id}/share/facebook?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback
