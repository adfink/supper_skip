require 'rails_helper'

describe 'the registered user', type: :feature do
  context 'when placing an order' do
    before(:each) do
      owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      @category_a = @restaurant_a.categories.create(name: "Sweets")
      @category_b = @restaurant_b.categories.create(name: "Pastas")

      @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
      @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])

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

    it 'does not create a duplicate order if user clicks back button after order confirmation' do
      expect(OnlineOrder.all.count).to eq(0)
      find("button[@type='submit']").click

      visit addresses_path
      click_on "Enter a New Address"

      fill_in('City', with: "Denver")
      fill_in('Street address', with: "123 Mountain Street")
      select "Colorado", :from => "State"
      fill_in('Zip', with: '80228')
      click_button('Create Address')

      expect(page).to have_content("Please Choose an Address")
      expect(current_path).to eq(addresses_path)

      click_on('Use This Address')
      expect(page).to have_content("Thank You For Ordering")
      expect(OnlineOrder.all.count).to eq(1)

      visit "/users/#{@user.id}/online_orders/new"

      expect(page).to have_content("Please add items to your cart before checking out. Thank you!")
      expect(OnlineOrder.all.count).to eq(1)
    end

    it "can place a delivery order, then cancel" do
      visit addresses_path

      click_on "Enter a New Address"
      fill_in('Street address', with: "123 Mountain Street")
      fill_in('City', with: 'Denver')
      select "Colorado", :from => "State"
      fill_in('Zip', with: '80228')

      click_button('Create Address')

      expect(page).to have_content("Please Choose an Address")
      expect(current_path).to eq(addresses_path)

      click_on("Use This Address")
      expect(page).to have_content("Thank You For Ordering")

      click_on('Review Existing Orders')
      click_on @user.online_orders.first.id
      first(:link, "Cancel").click

      expect(page).to have_content("Order Status Updated!")
      expect(page).to have_content("Cancelled")
    end

    it 'is prompted to select or create an address' do
      visit addresses_path

      expect(page).to have_content("Please Choose an Address")
      expect(page).to have_button("Enter a New Address")
    end

    describe 'when placing a wrong delivery address', type: :feature do

      it 'cannot proceed with any blank address field' do
        visit addresses_path

        click_on "Enter a New Address"
        fill_in('Street address', with: "123 Mountain Street")
        select "Colorado", :from => "State"
        fill_in('Zip', with: '80228')

        click_button('Create Address')

        expect(page).to_not have_content("Thank You For Ordering")
        expect(page).to have_css("#errors")
      end
    end
  end
end
