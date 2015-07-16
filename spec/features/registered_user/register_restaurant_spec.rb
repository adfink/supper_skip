require 'rails_helper'

describe 'normal user', type: :feature do

  before(:each) do
    owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

    @category_a = @restaurant_a.categories.create(name: "Sweets")
    @category_b = @restaurant_b.categories.create(name: "Pastas")

    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
    @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])

    @user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

    login_as(@user)
  end

  it 'can register new restaurant & becomes admin for that restaurant' do
    visit restaurants_path
    expect(page).to have_button('Register a New Restaurant')

    click_on "Register a New Restaurant"

    fill_in('Name', with: 'Restaurant Name')
    fill_in('Description', with: 'Restaurant Description')
    fill_in('Display name', with: 'restaurant-name')

    click_button('Create Restaurant')

    expect(current_path).to eq('/restaurants/restaurant-name')
    # expect(page).to have_content('Restaurant Name')
    #TODO user's admin role
  end

  xit 'shows items for a given restaurant' do
    visit restaurant_path(@restaurant_b)

    assert page.has_content?(@item_b.name)
    refute page.has_content?(@item_a.name)

    visit restaurant_path(@restaurant_a)
    assert page.has_content?(@item_a.name)
    refute page.has_content?(@item_b.name)

    click_on(@item_a.name)

    expect(current_path).to eq("/restaurants/edible/items/#{@item_a.id}")
    expect(page).to have_content(@item_a.description)
  end
end
