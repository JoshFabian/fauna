class Tegu.ListingReportModal
  @close: () ->
    $('#listing-report-modal').foundation('reveal', 'close')

$(document).ready ->

  $("#listing-report-modal a.button").on 'click', (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).data('listing-id')
    report_message = $(modal).find("textarea").val()
    console.log "listing:#{listing_id} report ..."
    data = {report: {message: report_message}}
    async.waterfall [
      (callback) ->
        # create report
        Tegu.ReportApi.create(listing_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.ListingReportModal.close()
    ]


