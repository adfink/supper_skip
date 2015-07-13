require 'rails_helper'

RSpec.describe "unauthenicated user" do
  context "when not signed in" do

    before(:each) do
      restaurant_a = Restaurants.new(name: 'Edible Objects', description: 'Tasty')
      @item = restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)

      @user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

      @order = OnlineOrder.create!(user_id: @user.id, item_id: @item.id, total: 20)

#TODO Check test, written correctly? Is it properly creating an order?
    end

    xit "cannot view past orders1 page" do
      visit restaurant_orders_path

      expect(current_path).to eq('/restaurant/users/new')
      expect(page).to have_content("PLEASE LOG IN OR CREATE ACCOUNT TO COMPLETE ORDER")
    end
  end
end
