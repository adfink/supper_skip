class AddOnlineOrderIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :online_order, index: true
  end
end
