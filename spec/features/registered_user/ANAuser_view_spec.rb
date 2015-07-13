require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the user view', type: :feature do

  describe 'cart interaction', type: :feature do
    before do
      @user = user_with({email_address: 'John@example.com', role: 'user'})
      @user.save
      login_as(@user)

      create_item_associated_with_a_category
      visit '/categories'
    end

    it 'completes an order for pickup' do
      page.find('#cart_button').click
      click_on('cart')
      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      expect(page).to have_css('#confirmation_message')
      page.find("#continue_shopping").click
      page.find("#cart_btn").click
      expect(page).to_not have_content('dandelion salad')
      order = Order.last
      expect(order.order_items.count).to eq(1)
      expect(order.order_items.last.id).to eq(1)
      expect(order.user_id).to eq(@user.id)
    end

    it 'sees an item counter next to cart' do
      2.times do
        page.find('#cart_button').click
      end
      expect(page).to have_content('2')
    end

    it 'does not create a duplicate order if user clicks back button after order confirmation' do
      expect(Order.all.count).to eq(0)
      page.find('#cart_button').click
      page.find("#cart_btn").click
      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      expect(Order.all.count).to eq(1)
    end

    it 'is prompted for an address when designating pick up order' do
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

    it 'has an option to review placed orders after placing an order' do
      page.find('#cart_button').click
      page.find("#cart_btn").click
      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      page.find("#review_orders_btn").click
      expect(current_path).to eq(orders_path)
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

    it 'can delete an address' do
      page.find('#cart_button').click
      page.find("#cart_btn").click
      page.find("#ckout_btn").click
      page.find("#delivery_btn").click
      page.fill_in('Street address', with: "123 Mountain Street")
      page.fill_in('City', with: 'Denver')
      select "Colorado", :from => "State"
      page.fill_in('Zip', with: '80228')
      page.click_button('Create Address')
      expect(page).to have_content("123 Mountain Street")
      page.click_button('Delete Address')
      expect(page).to_not have_content("123 Mountain Street")

    end
  end

  describe 'user order', type: :feature do
    before do
      user = create(user_with)
      create_order_with_order_item(user)
      login_as(user)
      visit '/orders'
    end
    it 'shows order' do
      order = Order.last
      within '.orders_smorders' do
        first(:link).click
      end
      expect(current_path).to eq(order_path(order))
    end
  end
end
