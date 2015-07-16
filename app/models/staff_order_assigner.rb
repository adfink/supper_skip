class StaffOrderAssigner
  def initialize(order, user, status)
    @order  = order
    @user   = user
    @status = status
  end

  def check_order_status
    # binding.pry
    if prepare? || deliver?
      send_message
      @order.update(staff_id: @user.id)
    end
  end

  def send_message
    binding.pry
    if @order.user.phone
      client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      client.messages.create from: '(414) 422-8148', to: @order.user.phone.to_i, body: "Hey guess what!? Your food is now being prepared!" if prepare?
      client.messages.create from: '(414) 422-8148', to: @order.user.phone.to_i, body: "Hey guess what!? Your food is on it's way to your tummy!" if deliver?
    end
  end

  def prepare?
    @status == 'prepare'
  end

  def deliver?
    @status == 'deliver'
  end
end
