class RenameOrdersTableToFoodOrders < ActiveRecord::Migration
  def change
    rename_table :orders, :food_orders
  end
end
