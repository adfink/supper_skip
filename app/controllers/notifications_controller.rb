class NotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    NotificationMailer.staff_registration_email(params[:email]).deliver_now
    redirect_to root_path
  end

  def notify(status)
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '(414) 422-8148', to: '(262) 391-1895', body: "Hey guess what!? Your order's status is now #{status}"
    render plain: message.status
    # redirect_to
  end

end
