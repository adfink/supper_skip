require 'rails_helper'

RSpec.describe Item, :type => :model do

  let(:item) do
    owner = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant = owner.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @category = @restaurant.categories.create(name: "Sweets")

    @item = @restaurant.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 20, categories: [@category])
  end

  it 'can create an item' do
    expect(item).to be_valid
  end

  it 'will not create an item if it does not have a name' do
    item.name = nil
    expect(item).to_not be_valid
  end

  it 'will not create an item if it does not have a price of greater than zero' do
    item.price = -5
    expect(item).to_not be_valid
  end

  it 'will not create an item if it does not have a status on the approved list' do
    item.status = "yummy"
    expect(item).to_not be_valid
  end
end
