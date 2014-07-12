module Endpoints
  class PlanApi < Grape::API
    format :json

    resource :plans do
      desc "Get plan data"
      get ':id' do
        authenticate!
        plan = Plan.find(params.id)
        {plan: plan}
      end
    end # plans
  end # api
end