class Tegu.UserRoutes
  @user_listings_route: (user_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.UserApi.get(user_id, token, cb)
      (data, cb) ->
        callback(null, "/#{data.user.handle_lower}/listings")
    ]

  @user_reviews_route: (user_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.UserApi.get(user_id, token, cb)
      (data, cb) ->
        callback(null, "/#{data.user.handle_lower}/reviews")
    ]
