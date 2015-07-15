class AddStaffIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :staff_id, :integer
  end
end
