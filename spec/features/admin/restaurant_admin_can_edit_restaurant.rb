require "rails_helper"

RSpec.describe "store admin can edit their own store", type: :feature do

  before(:each) do
    @user = User.create(full_name: "Justin Timberlake", email_address: "justin@justin.com", password: "password", screen_name: "justin")

    @admin = User.create!(full_name: "Jack Spade",
                          email_address: "jack@sample.com",
                          screen_name: "jackie",
                          password: "password",
                        )
    @restaurant_a = @admin.restaurants.create(name: "Applebees", description: "American food.", display_name: "applebees")
    @restaurant_b = @user.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

    @role = Role.create(name: "admin")
    user_role = UserRole.create!(user_id: @admin.id, restaurant_id: @restaurant.id, role_id: @role.id)
    @admin.user_roles << user_role

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "can edit their own store" do
    visit restaurant_path(@restaurant_a)
    click_on "Edit Restaurant"

    fill_in "Name", with: "The legendary Applebees"
    click_button "Update Restaurant"

    expect(page).to have_content('The legendary Applebees')
    expect(page).to have_content('Restaurant was successfully updated')
  end

  it "cannot edit another persons store" do
    visit restaurant_path(@restaurant_b)

    expect(page).to_not have_content('Edit Restaurant')
    expect(page).to_not have_content('Create a New Item')
  end
end
