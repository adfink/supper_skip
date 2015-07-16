require 'rails_helper'

RSpec.describe Item, :type => :model do

  let(:order_item) do
    owner = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant = owner.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @category = @restaurant.categories.create(name: "Sweets")

    @item = @restaurant.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 20, categories: [@category])

    OrderItem.new(order_id: 1, item_id: @item.id, quantity: 3 )
  end

  it 'is valid' do
    expect(order_item).to be_valid
  end

  it 'is not valid without a order_id' do
    order_item.order_id = nil
    expect(order_item).to_not be_valid
  end

  it 'is not valid without an item_id' do
    order_item.item_id = nil
    expect(order_item).to_not be_valid
  end

  it 'calculates a line total' do
    expect(order_item.line_total).to eq(60)
  end

end
