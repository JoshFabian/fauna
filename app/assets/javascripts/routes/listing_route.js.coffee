class Tegu.ListingRoute
  @new_route: () ->
    "/listings/new"

  @check_share_route: (user_slug, listing_id, token, callback) ->
    callback(null, "/#{user_slug}/listings/#{listing_id}/check-share")

  @show_route: (user_handle, listing_slug) ->
    "/#{user_handle}/listings/#{listing_slug}"

  @show_route_resolve: (user_slug, listing_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.ListingApi.get(listing_id, token, cb)
      (data, cb) ->
        callback(null, "/#{user_slug}/listings/#{data.listing.slug}")
    ]
