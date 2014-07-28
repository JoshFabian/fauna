module Endpoints
  class ChartApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({ status: "error", error: e.message })
    end

    resource :charts do

      desc "Listing category data"
      get 'listings/categories' do
        data = Category.roots.pluck(:name, :listings_count)
        logger.post("tegu.api", log_data.merge({event: 'charts.listings.categories'}))
        data
      end

      desc "Listing created data"
      get 'listings/created' do
        data = Listing.pluck(:created_at).group_by{ |datetime| datetime.to_s(:date_yyyymmdd) }
        data = data.inject({}) do |hash, tuple|
          hash[tuple[0]] = 0 if hash[tuple[0]].blank?
          hash[tuple[0]] += 1
          hash
        end
        logger.post("tegu.api", log_data.merge({event: 'charts.listings.created'}))
        data
      end

      desc "User signup data"
      get 'users/signups' do
        data = User.pluck(:created_at).group_by{ |datetime| datetime.to_s(:date_yyyymmdd) }
        data = data.inject({}) do |hash, tuple|
          hash[tuple[0]] = 0 if hash[tuple[0]].blank?
          hash[tuple[0]] += 1
          hash
        end
        logger.post("tegu.api", log_data.merge({event: 'charts.users.signups'}))
        data
      end

    end # charts
  end
end