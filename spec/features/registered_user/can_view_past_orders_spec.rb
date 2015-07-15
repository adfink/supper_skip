require 'rails_helper'

RSpec.describe "authenicated user" do
  context "when signed in" do

    before(:each) do
      owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit')
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
      @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

      @user = User.create!(full_name: 'Billy', email_address: 'billy@email.com', password: 'password', password_confirmation: 'password', screen_name: 'Billy')

      visit restaurant_path(@restaurant_a)
      click_on "add to cart"

      visit restaurant_path(@restaurant_b)
      click_on "add to cart"

      login_as(@user)

      visit '/'
      click_on("Toggle navigation")
      find('#cart').click

      click_on('Checkout')
      find("button[@type='submit']").click

      visit addresses_path
      click_on "Enter a New Address"
      fill_in('City', with: "Denver")
      fill_in('Street address', with: "123 Mountain Street")
      select "Colorado", :from => "State"
      fill_in('Zip', with: '80228')
      click_button('Create Address')
      click_on('Use This Address')
    end

    it "can view past orders page" do
      expect(page).to have_content("Thank You For Ordering")
      click_on "Review Existing Orders"

      expect(current_path).to eq("/users/#{@user.id}/online_orders")
      expect(page).to have_content("Order created")
    end
  end
end
