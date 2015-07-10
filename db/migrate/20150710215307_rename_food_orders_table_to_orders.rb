class RenameFoodOrdersTableToOrders < ActiveRecord::Migration
  def change
    rename_table :food_orders, :orders
  end
end
