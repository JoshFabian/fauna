class TwilioController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # POST /twilio/sms/reply
  def sms_reply
    
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.reply', from: params[:From], body: params[:Body]}))
  end

  # POST /twilio/sms/send?to=+13125551212
  def sms_send
    Phone.send_sms(to: params[:to], body: "test: #{rand(100)}")
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.send', to: params[:to]}))
  end

  # POST /twilio/sms/test?
  def sms_test
  end

end