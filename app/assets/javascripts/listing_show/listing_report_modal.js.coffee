class Tegu.ListingReportModal
  @open: (listing_id) ->
    $('#listing-report-modal').find("#listing_id").val(listing_id)
    $('#listing-report-modal').find("textarea").val("")
    $('#listing-report-modal').foundation('reveal', 'open')

  @close: () ->
    $('#listing-report-modal').foundation('reveal', 'close')

$(document).ready ->

  $(document).on 'click', '.listing-report-modal-open', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} report modal open ..."
    Tegu.ListingReportModal.open(listing_id)

  $(document).on 'click', "#listing-report-modal a.button", (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).find("#listing_id").val()
    report_message = $(modal).find("textarea").val()
    return if !report_message
    console.log "listing:#{listing_id} report ..."
    async.waterfall [
      (callback) ->
        # create report
        Tegu.ReportApi.create(listing_id, {report: {message: report_message}}, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.ListingReportModal.close()
    ]


