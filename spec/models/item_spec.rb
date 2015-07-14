require 'rails_helper'

RSpec.describe Item, :type => :model do

  let(:item) do
  Item.new(name: 'possum pie', description: "delicious, yummy, delicious, yummy, delicious, yummy,delicious, yummy,delicious, yummy,", price: 5, status: "active")
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
