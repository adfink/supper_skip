require 'rails_helper'

describe UsersController, :type => :controller do
  it 'can create user' do
    expect do
      post :create, user: {full_name: 'Jo Jo',
                           email_address: 'jojo@example.com',
                           screen_name: 'jojo',
                           password: 'jojojojo',
                           password_confirmation: 'jojojojo' }
    end.to change(User, :count).by(1)
    response.should be_redirect
  end

  it 'cannot create admin' do
    expect do
      post :create, user: {full_name: 'Jo Jo',
                           email_address: 'jojo@example.com',
                           screen_name: 'jojo',
                           password: 'jojojojo',
                           password_confirmation: 'jojojojo',
                           role: 'admin' }
    end.to change(User, :count).by(1)
    # response.should_not be_redirect
    User.last.role.should be_nil
  end
end
