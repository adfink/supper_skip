require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { Restaurant.create(name: 'Applebees', description: 'Terrible food', display_name: 'applebees')}
  let(:restaurant3) { Restaurant.create(name: 'The Applebees', description: 'Terrible food')}

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
end
