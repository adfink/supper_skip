class UpdateOpenColumnOnOrders < ActiveRecord::Migration
  def change
    change_column :orders, :open, :boolean, default: true
  end
end
