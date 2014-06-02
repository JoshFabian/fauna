class TwilioController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # POST /twilio/sms/reply
  def sms_reply
    
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.reply', from: params[:from], body: params[:body]}))
  end

  # POST /twilio/sms/send?to=+13125551212
  def sms_send
    
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.send', to: params[:to]}))
  end

end