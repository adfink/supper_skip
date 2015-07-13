require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the admin view', type: :feature do
  before(:each) do
    @owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit')
    @owner2 = User.create(full_name: 'Bobby Brown', email_address: 'bobby@bobby.com', password: 'password', password_confirmation: 'password', screen_name: 'bobby')

    @restaurant_a = @owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @restaurant_b = @owner2.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

    # category_a = restaurant_a.category.create(name: "Sweets")
    # category_b = restaurant_b.category.create(name: "Pastas")
    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
    @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

    @user = User.create!(full_name: 'Billy', email_address: 'billy@email.com', password: 'password', password_confirmation: 'password', screen_name: 'Billy')

    login_as(@owner1)
  end

  it 'can have admin capabilities for their restaurant' do
    visit restaurant_path(@restaurant_a)
    expect(page).to have_link("Edit Restaurant")
    expect(page).to have_link("Create New Restaurant Item")
    expect(page).to have_link("Create New Category")

    visit '/restaurant/olive-garden'
    expect(page).to_not have_link("Edit Restaurant")
    expect(page).to_not have_link("Create New Restaurant Item")
    expect(page).to_not have_link("Create New Category")
  end

  xit 'can create new item' do
    visit '/restaurants/edible'
    click_on("Create New Restaurant Item")

    expect(page).to have_content("Create Your New Item")

    fill_in("Name", with: "Breadsticks")
    fill_in("Description", with: "Buttery, flakey, fresh out of the oven breadsticks!")
    fill_in("Price", with: 8)
    click_button 'Create Item'

    expect(current_path).to eq(restaurants_path(@restaurant_a))
    expect(page).to have_content("Breadsticks")
  end

  xit 'can modify item name, description, and/or price' do
    visit '/restaurants/edible'

    click_on("#{@item_a.name}")

    expect(page).to have_content("Edit Item")
    click_on "Edit Item"

    expect(current_path).to eq(edit_restaurant_item_path(@restaurant_a, @item_a))
    expect(page).to have_content("Breadsticks")
    expect(page).to have_content(8)

    fill_in("Name", with: "Breadsticks Basket")
    fill_in("Description", with: "Fresh out of the oven bread! Yum!")
    fill_in("Price", with: 10)

    click_on "Make Changes"

    expect(current_path).to eq(restaurant_item_path(@restaurant_a, @item_a))
    expect(page).to have_content("Breadsticks Basket")
    expect(page).to_not have_content("Buttery, flakey, fresh out of the oven breadsticks!")
    expect(page).to_not have_content(8)
  end

  xit can delete an item do

  end

  xit 'can_change_item_category' do
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

  xit 'can create a category from the admin face' do
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

  xit 'can edit a category from the admin face' do
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

  xit 'can delete??? a category when logged in as an admin' do
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
end
