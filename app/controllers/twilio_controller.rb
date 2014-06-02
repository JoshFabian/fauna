class TwilioController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # POST /twilio/sms/reply
  def sms_reply
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.reply', from: params[:From], body: params[:Body]}))
  end

  # POST /twilio/sms/send?to=+13125551212
  def sms_send
    @phone_token = current_user.phone_tokens.create(to: params[:to])
    @phone_token.send_sms(to: @phone_token.to, body: "code: #{@phone_token.code}")
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.send', to: @phone_token.to, code: @phone_token.code}))
    redirect_to twilio_sms_test_path
  end

  # GET /twilio/sms/test
  def sms_test
  end

end