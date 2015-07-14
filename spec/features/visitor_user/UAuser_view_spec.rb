require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'


describe 'the user view', type: :feature do

  let(:user) { User.create(full_name: "Tom Petty",
                           screen_name: "Tom",
                           email_address: "tom@petty.com",
                           password: "freefallin",
                           password_confirmation: "freefallin") }

  describe 'account creation', type: :feature do
    it 'can create user credentials' do
      visit '/'
      page.click_link('Register')

      page.fill_in('Full name', with: 'Joe User')
      page.fill_in('Email address', with: 'joe@email.com')
      page.fill_in('Password', with: '1234')
      page.fill_in('Password confirmation', with: '1234')
      page.fill_in('Screen name', with: 'Joe')
      page.click_button('Create Account')

      expect(page).to have_content('You Have Successfully Created A New Account!')
      # expect(page).to have_link('Logout')
    end
  end

  describe 'authentication', type: :feature do
    it 'can login' do
      login_as(user)

      expect(page).to have_link('Logout')
    end

    it 'can log out' do
      login_as(user)
      page.click_on('Logout')

      expect(page).to have_link('Login')
    end
  end


  describe 'cart interaction', type: :feature do
    it 'returns to shopping after opening cart' do
      visit '/'
      click_on("Toggle navigation")
      find('#cart').click

      click_on('Continue Shopping')

      expect(current_path).to eq(restaurants_path)
    end

    it 'cannot view or use admin functionality' do
      visit '/admin'
      assert page.status_code == 404
      visit '/admin/dashboard'
      assert page.status_code == 404
      visit '/admin/orders'
      assert page.status_code == 404
      visit '/admin/items'
      assert page.status_code == 404
      visit '/admin/categories'
      assert page.status_code == 404
    end

    it 'can not proceed to checkout' do
      visit '/'

      click_on("Toggle navigation")
      find('#cart').click

      click_on('Checkout')

      expect(current_path).to eq(login_path)
    end
  end
end
