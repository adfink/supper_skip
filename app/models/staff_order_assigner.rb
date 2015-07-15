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
  end

  def deliver?
    @status == 'deliver'
  end
end
