module Endpoints
  class WaitlistApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :waitlists do
      helpers do
        def waitlist_params
          ActionController::Parameters.new(params).require(:waitlist).permit(:email, :referer, :role)
        end
      end

      desc "Create waitlist"
      post '' do
        @waitlist = Waitlist.find_or_create_by(waitlist_params)
        {waitlist: @waitlist}
      end

      desc "Update waitlist"
      put ':id' do
        @waitlist = Waitlist.find(params.id)
        @waitlist.update(waitlist_params)
        {waitlist: @waitlist}
      end

      desc "Check waitlist"
      get 'check' do
        @waitlist = Waitlist.find_by_email(params.email)
        {waitlist: @waitlist}
      end
    end
  end
end