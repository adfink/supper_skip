class StaffOrderAssigner
  def initialize(order, user, status)
    @order  = order
    @user   = user
    @status = status
  end

  def check_order_status
    if prepare? || deliver?
      @order.update(staff_id: @user.id)
    end
  end

  def prepare?
    @status == 'prepare'
    if @user.phone
      client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      message = client.messages.create from: '(414) 422-8148', to: @user.phone, body: "Hey guess what!? Your order's status is now #{@status}"
    end
  end

  def deliver?
    @status == 'deliver'
    if @user.phone
      client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      message = client.messages.create from: '(414) 422-8148', to: @user.phone, body: "Hey guess what!? Your order's status is now #{status}"
    end
  end
end
