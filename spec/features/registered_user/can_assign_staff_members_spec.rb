require 'rails_helper'

describe 'can assign staff members', type: :feature do
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
    @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
    @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)
    visit root_path
  end

  it 'can add staff members to restaurant' do
    login_as(owner1)
    visit restaurant_path(@restaurant_b)

    expect(page).to_not have_content('Add staff')

    visit restaurants_path
    first(:button, "Shop!").click

    expect(page).to have_content('Add staff')

    click_on 'Add staff'
    fill_in 'user_role_user_id', :with => owner2.email_address
    find('#user_role_role_id', :match => :first).find(:xpath, 'option[2]').select_option
    click_on 'Create User role'

    expect(page).to have_content('you just hired a new staff person')
    expect(page).to have_content(owner2.full_name)
  end

  it 'staff members can change status of orders' do
    online_order = user1.online_orders.create
    UserRole.create(user_id: owner2.id, restaurant_id: @restaurant_a.id, role_id: @cook.id)
    UserRole.create(user_id: user2.id, restaurant_id: @restaurant_a.id, role_id: @dp.id)
    Order.create(user_id: user1.id, restaurant_id: @restaurant_a.id, online_order_id: online_order.id)
    login_as(owner2)

    visit restaurants_path
    first(:button, "Shop!").click
    click_on 'Restaurant Order History'

    expect(page).to have_content('Ready for preparation')

    click_on 'In Preparation'

    expect(page).to have_content('In preparation')
    expect(page).to_not have_content('Ready for preparation')

    click_on 'Ready For Delivery'

    expect(page).to have_content('Ready for delivery')
    expect(page).to_not have_content('In preparation')
    expect(page).to_not have_content('Out For Delivery')

    login_as(user2)
    visit restaurants_path
    first(:button, "Shop!").click
    click_on 'Restaurant Order History'

    expect(page).to have_content('Out For Delivery')

    click_on 'Out For Delivery'

    expect(page).to have_content('Mark As Complete')

    click_on 'Mark As Complete'

    expect(page).to have_content('Order status updated')
    expect(page).to have_content('Completed')
  end
end
