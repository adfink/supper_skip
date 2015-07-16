require 'rails_helper'

describe 'can manage categories', type: :feature do
  let(:owner1){ User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit') }
  let(:owner2){ User.create(full_name: 'Justin Timberlake', email_address: 'justin@justin.com', password: 'password', password_confirmation: 'password', screen_name: 'JT') }
  let(:user1){ User.create(full_name: 'asdf', email_address: 'asdf@asdf.com', password: 'password', password_confirmation: 'password', screen_name: 'asdf') }
  let(:user2){ User.create(full_name: 'delivery boy', email_address: 'db@db.com', password: 'password', password_confirmation: 'password', screen_name: 'db') }

  before(:each) do
    @admin = Role.create(name: 'admin')
    @cook = Role.create(name: 'cook')
    @dp = Role.create(name: 'delivery person')
    @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @restaurant_b = owner2.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")
    UserRole.create(user_id: owner1.id, restaurant_id: @restaurant_a.id, role_id: @admin.id)
    UserRole.create(user_id: owner2.id, restaurant_id: @restaurant_b.id, role_id: @admin.id)

    @category_a = @restaurant_a.categories.create(name: "Sweets")
    @category_b = @restaurant_b.categories.create(name: "Pastas")

    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 20, categories: [@category_a])
    @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plastic', price: 25, categories: [@category_b])

    # @item_c = @restaurant_b.categories.first.items.create(name: 'Grapes', description: 'mmmmmDefinitely not made of plasticasdfasdfasdfa', price: 25)
    visit root_path
  end

  it 'can add category to restaurant' do
    login_as(owner1)
    visit restaurants_path
    first(:button, "Shop!").click

    expect(page).to have_content('Edible Objects')
    expect(page).to have_content('Organic Matter')

    click_link  ("Create New Category")
    expect(page.current_path).to eq(new_restaurant_category_path(@restaurant_a))
    fill_in('Name', with: 'Moldy Food')
    fill_in('Description', with: 'Mold gets a bad rap. it so nutritious and its so cheap to make that it just really makes sense to eat all the time')

    click_button('Create Category')

    expect(page).to have_content('Moldy Food')

  end

  it 'can edit categories of restaurant' do
    login_as(owner1)
    visit restaurants_path
    first(:button, "Shop!").click

    expect(page).to have_content('Edible Objects')
    click_link('Sweets')
    click_on('Edit Category')
    fill_in('Name', with: 'Pastas')

    click_on('Update Category')
    expect(page).to have_content('Pastas')
    expect(page).to_not have_content('Unhealthy')
  end

  it 'can delete categories of restaurant' do
    login_as(owner1)
    visit restaurants_path
    first(:button, "Shop!").click

    click_link('Sweets')
    click_link('Delete Category')
    expect(page).to_not have_content('Sweets')
  end
end
