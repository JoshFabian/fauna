$(document).ready ->

  $("select#listing_shipping_from").on 'change', (e) ->
    listing_id = $(this).data('listing-id')
    shipping_from = $(this).find("option:selected").val()
    return if !listing_id and listing_id != 0
    console.log "listing:#{listing_id}:shipping from: #{shipping_from}"
    async.waterfall [
      (callback) ->
        # update listing state
        Tegu.ListingForm.get_shipping_table(listing_id, shipping_from, callback)
      (data, callback) ->
        # console.log data
        $(".shipping-table").replaceWith(data)
    ]
    
  if $(".shipping-table").length > 0
    console.log "init shipping table"
    $("select#listing_shipping_from").trigger('change')