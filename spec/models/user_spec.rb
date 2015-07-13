require 'rails_helper'

RSpec.describe User, :type => :model do
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

  it 'it is invalid without a plausibe email' do
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

end
