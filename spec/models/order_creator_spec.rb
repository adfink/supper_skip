require 'rails_helper'

RSpec.describe OrderCreator, :type => :model do

  before(:each) do
    @owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit')
    @restaurant_a = @owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @owner1.addresses.create(zip: 12345, state: 'Colorado', city: 'Denver', street_address: '123')
    @category = @restaurant_a.categories.create(name: "Sweets")
    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category])
    online_order = @owner1.online_orders.create
    @order = Order.create(user_id: @owner1.id, address_id: @owner1.addresses.first.id, restaurant_id: @restaurant_a.id, online_order_id: online_order.id)
    @oc = OrderCreator.new([], online_order, @owner1.addresses.first)
  end

  it 'is an OrderCreator object' do
    assert_equal OrderCreator, @oc.class
  end

  it 'creates orders' do
    assert_equal @owner1.id, @oc.make_order(@restaurant_a).user_id
  end

  it 'creates order items' do
    @oc.make_order_items(@order, { @item_a.id => 2 })
    assert_equal @order.order_items.count, 1
  end
end
