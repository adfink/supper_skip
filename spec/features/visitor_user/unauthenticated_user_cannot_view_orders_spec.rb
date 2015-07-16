require 'rails_helper'

RSpec.describe "unauthenicated user" do

  before(:each) do
    owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
    @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
    @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

    @category_a = @restaurant_a.categories.create(name: "Sweets")
    @category_b = @restaurant_b.categories.create(name: "Pastas")

    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
    @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])

    @user = User.create!(full_name: 'Billy', email_address: 'billy@email.com', password: 'password', password_confirmation: 'password', screen_name: 'Billy')
  end

  it "cannot view past orders page" do
    visit '/'

    expect(page).to have_content("Welcome to Eatsy")
    expect(page).to_not have_content("My Orders")
    expect(page).to have_content("Sign Up")

    visit '/users/5/online_orders'

    expect(current_path).to eq('/users/new')
    expect(page).to have_content("Create an Account")
  end

end
