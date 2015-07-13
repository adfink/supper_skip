require 'rails_helper'

describe 'the registered user', type: :feature do

  describe 'can place a', type: :feature do

    before(:each) do
      owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit')
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      # category_a = restaurant_a.category.create(name: "Sweets")
      # category_b = restaurant_b.category.create(name: "Pastas")
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
    end

    it "pick up order" do
      click_on('Pick Up')

      expect(page).to have_content("Thank You For Ordering")
    end

    it "delivery order" do
      click_on('Delivery')

      expect(page).to have_content("Thank You For Ordering")
    end
  end

  describe 'when placing a delivery order', type: :feature do

    it 'is prompted for an address' do
      page.find('#cart_button').click
      click_on('cart')
      page.find("#ckout_btn").click
      page.find("#delivery_btn").click
      page.fill_in('Street address', with: "123 Mountain Street")
      page.fill_in('City', with: 'Denver')
      page.select "Colorado", :from => "State"
      page.fill_in('Zip', with: '80228')
      page.click_button('Create Address')
      page.click_button('use this address')
      order = Order.last
      expect(order.address.city).to eq("Denver")
    end

    it 'cannot proceed with any blank address field' do
      page.find('#cart_button').click
      page.find("#cart_btn").click
      page.find("#ckout_btn").click
      page.find("#delivery_btn").click
      page.fill_in('Zip', with: '80228')
      page.click_button('Create Address')
      expect(page).to have_css("#errors")
      expect(page).to_not have_content("80228")
    end

    it 'does not create a duplicate order if user clicks back button after order confirmation' do
      expect(Order.all.count).to eq(0)
      page.find('#cart_button').click
      page.find("#cart_btn").click
      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      expect(Order.all.count).to eq(1)
    end


  end
end
