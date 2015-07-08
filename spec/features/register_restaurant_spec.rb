require 'rails_helper'

describe 'normal user', type: :feature do

  let(:user) { User.create(full_name: "Tom Petty",
                           screen_name: "Tom",
                           email_address: "tom@petty.com",
                           password: "freefallin" ) }

  before :each do
    ApplicationController.any_instance.stub(:current_user).and_return(user)
  end

  it 'can register new restaurant' do
    visit restaurants_path
    expect(page).to have_link('Register New Restaurant')

    click_on "Register New Restaurant"

    fill_in('Name', with: 'Restaurant Name')
    fill_in('Description', with: 'Restaurant Description')
    fill_in('Display name', with: 'Restaurant-Name')

    click_button('Create Restaurant')

    expect(current_path).to eq('/restaurants/restaurant-name')
    expect(page).to have_content("Restaurant Name")
  end

  it 'shows items for a given restaurant' do
    user_a = User.create(full_name: 'Tommy', screen_name: 'Tom', email_address: 'asdf@asdf.com', password: 'password')
    user_b = User.create(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@asdf.com', password: 'password')
    restaurant_a = user_a.restaurants.new(name: 'Edible Objects', description: 'Tasty')
    restaurant_b = user_b.restaurants.new(name: 'Olive Garden', description: 'Authentic Italian')
    restaurant_a.sanitize_display_name
    restaurant_b.sanitize_display_name
    restaurant_a.save
    restaurant_b.save
    item_a = restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
    item_b = restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

    visit restaurant_path(restaurant_b)
    # save_and_open_page
    within('li.item') do
      assert page.has_content?(item_b.name)
      refute page.has_content?(item_a.name)
    end

    visit restaurant_path(restaurant_a)
    within('li.item') do
      assert page.has_content?(item_a.name)
      refute page.has_content?(item_b.name)
    end

    click_on(item_a.name)

    expect(current_path).to eq("/restaurants/edible-objects/items/#{item_a.id}")
    expect(page).to have_content(item_a.description)
  end
end
