require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { Restaurant.create(name: 'Applebees', description: 'Terrible food', display_name: 'applebees')}

  it 'is valid' do
    expect(restaurant).to be_valid
  end

  it 'is associated with a user' do
    expect(restaurant).to respond_to(:user)
  end

  it 'sanitizes display name' do
    rest = Restaurant.new(name: 'Applebees', description: 'Terrible food', display_name: 'The Applebees')
    rest.sanitize_display_name
    rest.save

    expect(rest.display_name).to eq('the-applebees')
  end

  it 'creates a display name if none is given' do
    rest = Restaurant.new(name: 'The Applebees', description: 'Terrible food')
    rest.sanitize_display_name
    rest.save

    expect(rest.display_name).to eq('the-applebees')
  end

  it 'creates a display name if empty string' do
    rest = Restaurant.new(name: 'The Applebees', description: 'Terrible food', display_name: '')
    rest.sanitize_display_name
    rest.save

    expect(rest.display_name).to eq('the-applebees')
  end

  it 'is invalid if duplicate name' do
    restaurant1 = Restaurant.create(name: 'Applebees', description: 'Terrible food', display_name: 'asdfadsf')
    restaurant2 = Restaurant.create(name: 'Applebees', description: 'Terrible food', display_name: 'asdf')

    expect(restaurant2).to_not be_valid
  end

  it 'is invalid if duplicate display_name' do
    restaurant1 = Restaurant.create(name: 'Applebees', description: 'Terrible food', display_name: 'applebees')
    restaurant2 = Restaurant.create(name: 'The Applebees', description: 'Terrible food', display_name: 'applebees')

    expect(restaurant2).to_not be_valid
  end

  it 'is invalid if no name is given' do
    restaurant.name = nil

    expect(restaurant).to_not be_valid
  end
end
