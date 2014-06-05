class TwilioController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!, only: [:sms_list, :sms_test, :sms_send]
  before_filter :admin_role_required!, only: [:sms_list]

  # GET /sms/list
  def sms_list
    @tokens = PhoneToken.order("id desc")
  end

  # callable from twilio management console
  # POST /sms/reply
  def sms_reply
    logger.post("tegu.app", log_data.merge({event: 'twilio.sms.reply', from: params[:From], body: params[:Body]}))
  end

  # GET /sms/send
  def sms_send
  end

  # GET /sms/verify
  def sms_verify
  end

end