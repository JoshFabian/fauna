class Tegu.PlanApi
  @get: (plan_id, token, callback = null) ->
    api = "/api/v1/plans/#{plan_id}?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback
