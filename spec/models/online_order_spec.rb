require 'rails_helper'

RSpec.describe OnlineOrder, type: :model do
  let(:user){ User.create(full_name: "Jt", email_address: "adsf@asdf.com", password: "password", screen_name: "asdf")}
  let(:online_order){ OnlineOrder.create(user_id: user.id)}

  it 'is valid' do
    expect(online_order).to be_valid
  end

  it 'is valid' do
    expect(online_order).to respond_to(:user)
  end
end
