class CustomMessageMailer < ActionMailer::Base
  default from: lambda { |s|  CustomMessageMailer.default_from }

  add_template_helper(ApplicationHelper)

  # Sends and email for indicating a new message or a reply to a receiver.
  # It calls new_message_email if notifing a new message and reply_message_email
  # when indicating a reply to an already created conversation.
  def send_email(message, receiver)
    if message.conversation.messages.size > 1
      reply_message_email(message,receiver)
    else
      new_message_email(message,receiver)
    end
  end

  include ActionView::Helpers::SanitizeHelper

  # Sends an email for indicating a new message for the receiver
  def new_message_email(message, receiver)
    @message = message
    @sender = @message.sender
    @receiver = receiver
    @subject = "[Fauna] New Message from #{@sender.try(:handle)}"
    mail(to: @receiver.email, subject: @subject, template_name: 'new_message_email')
  end

  # Sends and email for indicating a reply in an already created conversation
  def reply_message_email(message, receiver)
    @message = message
    @sender = @message.sender
    @receiver = receiver
    @subject = "[Fauna] New Reply from #{@sender.try(:handle)}"
    mail(to: @receiver.email, subject: @subject, template_name: 'new_message_email')
  end

  protected

  def self.default_from
    if Rails.env.production?
      "Fauna Messaging <no-reply@fauna.net>"
    else
      "Fauna Messaging #{Rails.env.titleize} <no-reply@fauna.net>"
    end
  end

end