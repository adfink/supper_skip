require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the user view', type: :feature do

  describe 'cart interaction', type: :feature do
    before do
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

    it 'sees an item counter next to cart' do
      2.times do
        page.find('#cart').click
      end
      expect(page).to have_content('2')
    end

    it 'can delete an address' do
      click_on('Delivery')

      click_on "Enter a New Address"
      fill_in('Street address', with: "123 Mountain Street")
      fill_in('City', with: "Denver")
      select "Colorado", :from => "State"
      fill_in('Zip', with: '80228')

      click_button('Create Address')

      expect(current_path).to eq(addresses_path)
      expect(page).to have_content("123 Mountain Street")
      page.click_button('Delete Address')
      expect(page).to_not have_content("123 Mountain Street")
    end
  end
end
