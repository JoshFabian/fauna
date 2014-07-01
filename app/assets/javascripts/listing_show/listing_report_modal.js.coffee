class Tegu.ListingReportModal
  @close: () ->
    $('#listing-report-modal').foundation('reveal', 'close')

$(document).ready ->

  $("#listing-report-modal a.button").on 'click', (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).data('listing-id')
    report_body = $(modal).find("textarea").val()
    console.log "listing:#{listing_id} report ..."
    Tegu.ListingReportModal.close()

