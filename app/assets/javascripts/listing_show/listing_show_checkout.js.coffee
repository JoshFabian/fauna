class Tegu.CheckoutForm
  @disable_checkout_button: () ->
    $("a.checkout").addClass('secondary').addClass('disabled')

  @enable_checkout_button: () ->
    $("a.checkout").removeClass('secondary').removeClass('disabled')

  @hide_shipping_error: () ->
    $(".error-state").addClass('hide')

  @show_shipping_error: () ->
    $(".error-state").removeClass('hide')

$(document).ready ->

  shipping_to = 'na'

  # deprecated
  # $(".checkout-1").on 'click', (e) ->
  #   e.preventDefault()
  #   $(".listing-checkout-1").addClass('hide')
  #   $(".listing-checkout-2").removeClass('hide')
  #   $("select#listing_shipping_to").trigger('change')

  # deprecated
  # $(".shipping-country-radio").on 'click', (e) ->
  #   console.log "shipping to country"
  #   $("select#listing_shipping_to").trigger('change')

  # deprecated
  # $(".shipping-local-pickup-wrapper").on 'click', (e) ->
  #   listing_id = $(this).data('listing-id')
  #   console.log "listing:#{listing_id} local pickup"
  #   async.waterfall [
  #     (callback) ->
  #       # get listing local pickup price
  #       Tegu.ListingApi.get_shipping_price(listing_id, 'local', auth_token, callback)
  #     (data, callback) ->
  #       console.log data
  #       # update checkout form
  #       $(".checkout-shipping .price").html(data.listing.shipping_price_string)
  #       $(".checkout-total .price").html(data.listing.total_price_string)
  #   ]

  $(document).on 'change', "select#listing_shipping_to", (e) ->
    listing_id = $(this).data('listing-id')
    shipping_to = $(this).find("option:selected").val()
    if !shipping_to
      console.log "disable checkout ..."
      Tegu.CheckoutForm.show_shipping_error()
      Tegu.CheckoutForm.disable_checkout_button()
      return
    console.log "listing:#{listing_id}, shipping to:#{shipping_to}"
    async.waterfall [
      (callback) ->
        # get listing shipping price
        Tegu.ListingApi.get_shipping_price(listing_id, shipping_to, auth_token, callback)
      (data, callback) ->
        console.log data
        # update checkout button
        Tegu.CheckoutForm.hide_shipping_error()
        Tegu.CheckoutForm.enable_checkout_button()
        # update checkout form
        # $(".checkout-shipping .price").html(data.listing.shipping_price_string)
        # $(".checkout-total .price").html(data.listing.total_price_string)
    ]

  $(document).on 'click', "a.checkout", (e) ->
    e.preventDefault()
    if $(this).hasClass('disabled')
      return Tegu.CheckoutForm.show_shipping_error()
    if current_user == 0
      return window.location.href = Tegu.GuestRoute.login_route()
    $(this).addClass('disabled').text("Checking out ...")
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id}, shipping_to:#{shipping_to}"
    async.waterfall [
      (callback) ->
        # create payment
        Tegu.PaymentApi.create_payment(listing_id, shipping_to, auth_token, callback)
      (data, callback) ->
        console.log data
        if data.payment.payment_url
          window.location.href = data.payment.payment_url
    ]

  $(document).on 'click', "a.website", (e) ->
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} track website click ..."
    async.waterfall [
      (callback) ->
        # track website click
        Tegu.ListingApi.track_website_click(listing_id, auth_token, callback)
      (data, callback) ->
        # console.log data
    ]
