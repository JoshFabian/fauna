class Tegu.ListingRoute
  @new_route: () ->
    "/listings/new"

  @show_route: (user_slug, listing_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.ListingApi.get(listing_id, token, cb)
      (data, cb) ->
        callback(null, "/#{user_slug}/listings/#{data.listing.slug}")
    ]
