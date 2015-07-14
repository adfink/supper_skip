class RemoveOpenColumnFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :open
  end
end
