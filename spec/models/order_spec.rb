require 'rails_helper'

RSpec.describe Order, :type => :model do

  before(:each) do
    @owner = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant = @owner.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    category = @restaurant.categories.create(name: "Sweets")
    @item = @restaurant.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 3, categories: [category])

    @user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

    @order = Order.create(user_id: @owner.id, status: :ready_for_preparation)
    @order.order_items.create(item_id: @item.id, quantity: 5)
  end

  it 'can calculate a subtotal' do
    expect(@order.subtotal).to eq(15)
  end

  it 'can calculate tax' do
    expect(@order.tax).to eq(".75".to_f)
  end

  it 'can calculate a total' do
    expect(@order.total).to eq(15.75)
  end

end
