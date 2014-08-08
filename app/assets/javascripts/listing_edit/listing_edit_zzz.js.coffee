$(document).ready ->

  try
    if $("form.listing-edit").length > 0
      # init listing id
      Tegu.ListingForm.set_listing_id($("form.listing-edit").data('listing-id'))
      # init listin form
      Tegu.ListingForm.init()
  catch e
