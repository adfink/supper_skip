class TwilioNotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def notify(status)
    account_sid = "AC1ca0734f632a648db3b6fb7ad413a3ac"
    auth_token = "9faa19bfcf21bc41137255579f281e5b"
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '(414) 422-8148', to: '(262) 391-1895', body: "Hey guess what!? Your order's status is now #{status}"
    binding.pry
    render plain: message.status
  end


end
