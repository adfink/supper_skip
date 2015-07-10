class CreateOnlineOrders < ActiveRecord::Migration
  def change
    create_table :online_orders do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
