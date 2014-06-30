class Tegu.ListingReportModal
  @close: () ->
    $('#listing-report-modal').foundation('reveal', 'close')

$(document).ready ->

  $("#listing-report-modal a.button").on 'click', (e) ->
    e.preventDefault()
    listing_id = $('#listing-report-modal').data('listing-id')
    text = $('#listing-report-modal').find("textarea").val()
    console.log "listing:#{listing_id} report ..."
    Tegu.ListingReportModal.close()


  