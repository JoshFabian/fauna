class TwilioController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!, only: [:manage_sms, :sms_test, :sms_send]
  before_filter :admin_role_required!, only: [:sms_manage]

  # GET /sms/manage
  def sms_manage
    @tokens = PhoneToken.order("id desc")
  end

  # callable from twilio management console
  # POST /sms/reply
  def sms_reply
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.reply', from: params[:From], body: params[:Body]}))
  end

  # step 1
  # GET /:slug/verify/sms/send
  def sms_send
  end

  # step 2
  # GET /:slug/verify/sms/code
  def sms_code
  end

  # step 3
  # GET /:slug/verify/sms/complete
  def sms_complete
    redirect_to(session[:verify_phone_return_to])
  end

end