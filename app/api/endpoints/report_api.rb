module Endpoints
  class ReportApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({ status: "error", error: e.message })
    end

    resource :reports do
      desc "Create listing report"
      post ':listing_id' do
        authenticate!
        listing = Listing.find(params.listing_id)
        message = params.report.message rescue ''
        report = listing.reports.create(user: current_user, message: message)
        error!('Not Allowed', 400) if !report.persisted?
        logger.post("tegu.api", log_data.merge({event: 'report.create'}))
        {report: report}
      end
    end # reports
  end
end