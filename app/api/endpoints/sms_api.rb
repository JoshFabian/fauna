module Endpoints
  class SmsApi < Grape::API
    format :json

    resource :sms do
      desc "Send sms token"
      put 'token/send' do
        @phone_token = current_user.phone_tokens.create(to: params[:to])
        @phone_token.send_token(to: @phone_token.to, body: "code: #{@phone_token.code}")
        {event: @phone_token.state, token: @phone_token.as_json()}
      end

      desc "Verify sms token"
      put 'token/verify' do
        @phone_token = current_user.phone_tokens.find_by_code(params.code)
        @phone_token.verify! if @phone_token.present?
        {event: @phone_token.present? ? @phone_token.state : 'error'}
      end
    end
  end
end