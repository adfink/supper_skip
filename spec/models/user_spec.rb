require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:restaurant){ Restaurant.create(name: "Olive Garden", user_id: user.id) }
  let(:user) do
  User.new(full_name: "Joe Test",
           email_address: "Joe@test.com",
           password: '1234',
           password_confirmation: "1234")
  end

  it 'is valid' do
    expect(user).to be_valid
  end

  it 'is invalid without a full name' do
    user.full_name = nil
    expect(user).to_not be_valid
  end

  it 'accepts an optional screen_name' do
    user.screen_name = "Joe Awesome"
    expect(user).to be_valid
  end

  it 'it is invalid without a plausible email' do
    user.email_address = "Joe Awesome"
    expect(user).to_not be_valid
  end

  it 'it is invalid without a unique email' do
    2.times do
    User.create(email_address: "Joe@test.com", full_name: "Joe Test", password: '1234', password_confirmation: "1234")
    result = User.where(email_address: "Joe@test.com")
    assert_equal 1, result.count
    end
  end

  it 'is a cook' do
    cook = Role.create(name: 'cook')
    dp = Role.create(name: 'delivery person')
    UserRole.create(role_id: cook.id, user_id: user.id, restaurant_id: restaurant.id)
    assert_equal true, user.cook?(restaurant)
    assert_equal true, user.staff?(restaurant)
    assert_equal false, user.delivery_person?(restaurant)
  end

  it 'is a delivery person' do
    cook = Role.create(name: 'cook')
    dp = Role.create(name: 'delivery person')
    UserRole.create(role_id: dp.id, user_id: user.id, restaurant_id: restaurant.id)
    assert_equal true, user.delivery_person?(restaurant)
    assert_equal false, user.cook?(restaurant)
  end

  it 'is an admin' do
    admin = Role.create(name: 'admin')
    cook = Role.create(name: 'cook')
    dp = Role.create(name: 'delivery person')
    UserRole.create(role_id: admin.id, user_id: user.id, restaurant_id: restaurant.id)
    assert_equal false, user.delivery_person?(restaurant)
    assert_equal true, user.admin?(restaurant)
  end

  it 'my_order? works' do
    order = Order.create(restaurant_id: restaurant.id, staff_id: user.id)
    assert_equal true, user.my_order?(order)
  end
end
