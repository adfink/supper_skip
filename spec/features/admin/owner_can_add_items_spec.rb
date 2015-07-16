require 'rails_helper'

describe 'can create items', type: :feature do
  let(:owner1){ User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit') }
  let(:owner2){ User.create(full_name: 'Justin Timberlake', email_address: 'justin@justin.com', password: 'password', password_confirmation: 'password', screen_name: 'JT') }
  let(:user1){ User.create(full_name: 'asdf', email_address: 'asdf@asdf.com', password: 'password', password_confirmation: 'password', screen_name: 'asdf') }
  let(:user2){ User.create(full_name: 'delivery boy', email_address: 'db@db.com', password: 'password', password_confirmation: 'password', screen_name: 'db') }

  before(:each) do
    @admin = Role.create(name: 'admin')
    @cook = Role.create(name: 'cook')
    @dp = Role.create(name: 'delivery person')
    @restaurant_a = owner2.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")
    UserRole.create(user_id: owner1.id, restaurant_id: @restaurant_b.id, role_id: @admin.id)
    UserRole.create(user_id: owner2.id, restaurant_id: @restaurant_a.id, role_id: @admin.id)

    @category_a = @restaurant_b.categories.create(name: "Sweets")
    @category_b = @restaurant_a.categories.create(name: "Pastas")

    @item_a = @restaurant_b.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 20, categories: [@category_a])
    @item_b = @restaurant_a.items.create(name: 'Lasagna', description: 'Definitely not made of plastic', price: 25, categories: [@category_b])

    visit root_path
  end

  it 'can add items to restaurant' do
    login_as(owner2)
    visit restaurants_path
    first(:button, "Shop!").click

    expect(page).to have_content('Edible Objects')
    expect(page).to have_content('Lasagna')

    click_link  ("Create New Restaurant Item")
    expect(page.current_path).to eq(new_restaurant_item_path(@restaurant_a))

    fill_in('Name', with: 'Super good pudding')
    fill_in('Description', with: 'OMG this pudding is so effin good I just had an aneuryism... it was like... totally worth it')
    fill_in('Price', with: '80228')
    page.check("Pastas")

    click_on('Create Item')

    expect(page).to have_content('Super good pudding')

  end

  it 'can edit items of restaurant' do
    login_as(owner2)
    visit restaurants_path
    first(:button, "Shop!").click
    expect(page).to have_content('Edible Objects')
    expect(page).to have_content('Lasagna')
    click_link('Lasagna')
    within(".col-sm-4") do
      click_link('Edit Item')
    end
    fill_in('Name', with: 'Pasta')
    click_button('Update Item')
    expect(page).to have_content('Pasta')
    expect(page).to_not have_content('Lasagna')
  end

  it 'can delete items of restaurant' do
    login_as(owner2)
    visit restaurants_path
    first(:button, "Shop!").click
    expect(page).to have_content('Edible Objects')
    expect(page).to have_content('Lasagna')
    click_link('Lasagna')
    click_link('Delete Item')
    expect(page).to_not have_content('Lasagna')
  end

end


