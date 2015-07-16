require 'rails_helper'

RSpec.describe OnlineOrder, :type, :model do

  before(:each) do
    @owner = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant = @owner.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    category = @restaurant.categories.create(name: "Sweets")
    @item = @restaurant.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 15, categories: [category])

    @user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

    @online_order1 = OnlineOrder.create!(user_id: @owner.id)
    @online_order2 = OnlineOrder.create!(user_id: @owner.id)
  end


  context "is valid" do
    it "is valid with valid attributes" do
      expect(@online_order1).to be_valid
    end

    it "responds to user" do
      expect(@online_order1.user.id).to eq(@owner.id)
    end

    xit "can find it's order" do
      expect(@owner.online_orders.count).to eq(2)
      expect(@owner.online_orders.last.id).to eq(2)
    end
  end

  context "is invalid with invalid attributes" do
    it "is invalid without user_id" do
      order = OnlineOrder.create(created_at: Time.now)
      expect(order).to_not be_valid
    end
  end
end
