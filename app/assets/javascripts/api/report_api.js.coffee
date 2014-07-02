class Tegu.ReportApi
  @create: (listing_id, params, token, callback = null) ->
    api = "/api/v1/reports/#{listing_id}?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params
      success: (data) ->
        callback(null, data) if callback
      error: (data) ->
        callback(null, data) if callback
        