$(document).ready ->

  $("select#listing_shipping_from").on 'change', (e) ->
    listing_id = $(this).data('listing-id')
    shipping_from = $(this).find("option:selected").val()
    return if !listing_id and listing_id != 0
    console.log "listing:#{listing_id}:shipping from: #{shipping_from}"
    async.waterfall [
      (callback) ->
        # get listing shipping table
        Tegu.ListingForm.get_shipping_table(listing_id, shipping_from, callback)
      (data, callback) ->
        # console.log data
        $(".shipping-table").replaceWith(data)
    ]

  if $(".shipping-table").length > 0
    console.log "init shipping table"
    $("select#listing_shipping_from").trigger('change')

  $(document).on 'change', '.listing-shipping-from-checkbox', (e) ->
    tr = $(this).closest('tr')
    if $(this).prop('checked')
      $(tr).find("input.money").addClass('required')
    else
      $(tr).find("input.money").removeClass('required').val('')