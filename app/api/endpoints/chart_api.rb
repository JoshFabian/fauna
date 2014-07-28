module Endpoints
  class ChartApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({ status: "error", error: e.message })
    end

    resource :charts do

      desc "Listing created data"
      get 'listing_creates' do
        data = Listing.pluck(:created_at).group_by{ |datetime| datetime.to_s(:date_yyyymmdd) }
        data = data.inject({}) do |hash, tuple|
          hash[tuple[0]] = 0 if hash[tuple[0]].blank?
          hash[tuple[0]] += 1
          hash
        end
        logger.post("tegu.api", log_data.merge({event: 'charts.listing_creates', data: data}))
        data
      end

      desc "User signup data"
      get 'user_signups' do
        data = User.pluck(:created_at).group_by{ |datetime| datetime.to_s(:date_yyyymmdd) }
        data = data.inject({}) do |hash, tuple|
          hash[tuple[0]] = 0 if hash[tuple[0]].blank?
          hash[tuple[0]] += 1
          hash
        end
        logger.post("tegu.api", log_data.merge({event: 'charts.user_signups', data: data}))
        data
      end

    end # charts
  end
end