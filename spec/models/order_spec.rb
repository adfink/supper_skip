require 'rails_helper'

RSpec.describe Order, :type => :model do

  let(:order) do
    user = User.create(full_name: "Justin", email_address: "asdf@asdf.com", password: "password")
    online_order = user.online_orders.create
    restaurant = Restaurant.create(name: 'asdf', user_id: user.id)
    item = Item.create(name: 'possum pie', description: "delicious, yummy, delicious, yummy, delicious, yummy,delicious, yummy,delicious, yummy,", price: 5, status: "active")
    order_item = OrderItem.new(order_id: 1, item_id: item.id, quantity: 3 )
    Order.new(order_items: [order_item], restaurant_id: restaurant.id, user_id: user.id, online_order_id: online_order.id)
  end

  it 'is valid' do
    expect(order).to be_valid
  end

  it 'is invalid without status' do
    order.status = nil
    expect(order).to_not be_valid
  end

  it 'is associated with a user' do
    expect(order).to respond_to(:user)
  end

  it 'is associated with a restaurant' do
    expect(order).to respond_to(:restaurant)
  end

  it 'is associated with an online order' do
    expect(order).to respond_to(:online_order)
  end

  it 'is associated with an online order' do
    expect(order).to respond_to(:address)
  end

  it 'can calculate a total' do
    expect(order.total).to eq(15)
  end
end
