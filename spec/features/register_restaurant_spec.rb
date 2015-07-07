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


end
