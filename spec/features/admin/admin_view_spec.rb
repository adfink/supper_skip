require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the admin view', type: :feature do
  describe 'admin menu tasks', type: :feature do
    it 'can see dashboard' do
      visit items_path
      expect(page).to_not have_link('Admin Dashboard')
      user = user_with({})
      user.save
      page.fill_in('Email address', with: 'admin@example.com')
      page.fill_in('Password', with: '1234')
      page.click_button('Log In')
      expect(page).to have_link('Admin Dashboard')
      click_link 'Admin Dashboard'
      expect(page).to have_css('#dashboard_heading')
    end

    it 'can modify item name =' do
      create_item({})
      visit '/'
      user = user_with({})
      user.save
      login_as(user)
      click_link 'Admin Dashboard'
      click_link 'Manage Food Items'
      click_link 'Mountain Mud Pie'
      page.fill_in('Name', with: 'Valley Mud Pie')
      within('.save') do
        click_button 'Save'
      end
      expect(page).to have_content('Valley Mud Pie')
    end

    it 'can modify item description =' do
      create_item({})
      visit items_path
      user = user_with({})
      user.save
      login_as(user)
      click_link 'Admin Dashboard'
      click_link 'Manage Food Items'
      click_link 'Mountain Mud Pie'
      page.fill_in('Description', with: 'Muddy, muddy, Muddy, muddy, Muddy, muddy,Muddy, muddy,')
      click_button 'Save'
      click_link 'Mountain Mud Pie'
      expect(page).to have_content('Muddy, muddy, Muddy, muddy, Muddy, muddy,Muddy, muddy,')
    end

    it 'can modify item price =' do
      create_item({})
      visit items_path
      user = user_with({})
      user.save
      login_as(user)
      click_link 'Admin Dashboard'
      click_link 'Manage Food Items'
      click_link 'Mountain Mud Pie'
      page.fill_in('Price', with: 5.50)
      click_button 'Save'
      click_link 'Mountain Mud Pie'
      expect(page).to have_content(5.50)
    end

    it 'can_change_item_category' do
      create_category({})
      create_item({})
      visit items_path
      user = user_with({})
      user.save
      login_as(user)

      click_link 'Admin Dashboard'
      click_link 'Manage Food Items'
      click_link 'Mountain Mud Pie'
      check('Desserts')
      click_button 'Save'
      click_link 'Mountain Mud Pie'
      item = Item.find_by(name: 'Mountain Mud Pie')
      expect(item.categories.first.name).to eq('Desserts')
    end

    it 'can delete a category when logged in as an admin' do
      create_category({})
      create_item({})
      user = user_with({})
      user.save
      login_as(user)

      visit items_path
      click_link 'Admin Dashboard'

      click_link('Manage Food Categories')
      click_link('Desserts')
      click_button('Delete this Category')
      expect(page).to_not have_text('Desserts')
    end

    it 'can create a category from the admin face' do
      user = user_with({})
      user.save
      login_as(user)
      visit admin_categories_path
      click_link 'Create New Category'

      fill_in('Name', with: 'Desserts')
      click_link_or_button 'Save'
      expect(current_path).to eq(admin_categories_path)
      expect(page).to have_text('Category Successfully Created!')
    end

    it 'can edit a category from the admin face' do
       user = user_with({})
       user.save
       login_as(user)
       create_category({})
       visit admin_categories_path
       click_link 'Desserts'

       fill_in 'Name', with: 'Desserts!'
       click_button 'Save'
       expect(current_path).to eq(admin_categories_path)
       expect(page).to have_text('Category Successfully Updated!')
     end

    it 'can create/delete an item when logged in as an admin' do
      user = user_with({})
      user.save
      login_as(user)
      create_category({})

      visit items_path
      click_link 'Admin Dashboard'
      expect(page).to have_css('#dashboard')

      click_link('Manage Food Items')
      click_link('Create')
      fill_in 'Name', with: "Hamburger"
      fill_in 'Description', with: 'Yum Yum Yum Yum Yum Yum Yum Yum Yum'
      fill_in 'Price', with: '6.5'
      check('Desserts')
      click_button 'Save'
      expect(page).to have_content('Hamburger')

      click_link('Hamburger')
      click_button('Delete this item')
      expect(page).to_not have_text('Hamburger')
    end
  end
end
#
