require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role){ Role.create(name: 'admin') }

  it 'is valid' do
    expect(role).to be_valid
  end

  it 'has a name' do
    role.name = nil

    expect(role).to_not be_valid
  end
end
