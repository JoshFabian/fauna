class Tegu.UserRoute
  @user_listings_route: (user_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.UserApi.get(user_id, token, cb)
      (data, cb) ->
        callback(null, "/#{data.user.slug}/listings")
    ]

  @user_reviews_route: (user_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.UserApi.get(user_id, token, cb)
      (data, cb) ->
        callback(null, "/#{data.user.slug}/reviews")
    ]

  @user_verify_route: (user_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.UserApi.get(user_id, token, cb)
      (data, cb) ->
        callback(null, "/#{data.user.slug}/verify")
    ]

  @user_slug_route: (slug, s) ->
    if s then "/#{slug}/#{s}" else "/#{slug}"