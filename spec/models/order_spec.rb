require 'rails_helper'

RSpec.describe Order, :type => :model do

  let(:order) do
    @item = Item.create(name: 'possum pie', description: "delicious, yummy, delicious, yummy, delicious, yummy,delicious, yummy,delicious, yummy,", price: 5, status: "active")
    @order_item = OrderItem.new(order_id: 1, item_id: @item.id, quantity: 3 )
    Order.new(order_items: [@order_item])
  end

  xit 'cannot make an order with a different status' do
    order = Order.new(status: 'waiting')
    expect(order.valid?).to eq(false)
  end

  it 'can calculate a subtotal' do
    expect(order.subtotal).to eq(15)
  end

  it 'can calculate tax' do
    expect(order.tax).to eq(".75".to_f)
  end

  it 'can calculate a tota' do
    expect(order.total).to eq(15.75)
  end

end
