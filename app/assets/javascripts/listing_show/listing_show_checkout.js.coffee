$(document).ready ->

  $(".checkout-1").on 'click', (e) ->
    e.preventDefault()
    $(".listing-checkout-1").addClass('hide')
    $(".listing-checkout-2").removeClass('hide')
    $("select#listing_shipping_to").trigger('change')

  $(".shipping-country-radio").on 'click', (e) ->
    console.log "shipping to country"
    $("select#listing_shipping_to").trigger('change')

  $(".shipping-local-pickup-wrapper").on 'click', (e) ->
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} local pickup"
    async.waterfall [
      (callback) ->
        # get listing local pickup price
        Tegu.ListingApi.get_local_pickup_price(listing_id, auth_token, callback)
      (data, callback) ->
        console.log data
        # update checkout form
        $(".checkout-shipping .price").html(data.listing.shipping_price_string)
        $(".checkout-total .price").html(data.listing.total_price_string)
    ]

  $("select#listing_shipping_to").on 'change', (e) ->
    listing_id = $(this).data('listing-id')
    shipping_to = $(this).find("option:selected").val()
    console.log "listing:#{listing_id}, shipping to:#{shipping_to}"
    async.waterfall [
      (callback) ->
        # get listing shipping price
        Tegu.ListingApi.get_shipping_price(listing_id, shipping_to, auth_token, callback)
      (data, callback) ->
        console.log data
        # update checkout form
        $(".checkout-shipping .price").html(data.listing.shipping_price_string)
        $(".checkout-total .price").html(data.listing.total_price_string)
    ]
