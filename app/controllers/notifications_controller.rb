class NotificationsController < ApplicationController


  def create
    NotificationMailer.staff_registration_email(params[:email]).deliver_now
    redirect_to root_path
  end

  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '(414) 422-8148', to: '(262) 391-1895', body: 'Learning to send SMS you are.'
    render plain: message.status
  end

end
