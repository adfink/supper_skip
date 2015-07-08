require "rails_helper"

feature "unregistered user is able to shop items at multiple restaurants" do

  context "while not signed in" do

    before(:each) do
      restaurant_a = Restaurants.new(name: 'Edible Objects', description: 'Tasty')
      restaurant_b = Restaurants.new(name: 'Olive Garden', description: 'Authentic Italian')
      # category_a = restaurant_a.category.create(name: "Sweets")
      # category_b = restaurant_b.category.create(name: "Pastas")
      item_a = restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
      item_b = restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

      user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

      visit restaurant_path(restaurant_a)
      click_on "Edible Objects"
      click_on "add to cart"

      visit restaurant_path(restaurant_b)
      click_on "Olive Garden"
      click_on "add to cart"

      page.find('#cart_button').click
      click_on('cart')
    end

    xit "can click checkout and get routed to login or sign up" do
      #Tested in visitor user cart spec
      # expect(page).to have_content("Organic Matter")
      # expect(page).to have_content("Lasagna")
      # expect(page).to have_content(45)

      page.find("#ckout_btn").click

      expect(page).to have_content("Please Login or Sign Up first to purchase!")
      expect(current_path).to eq("/login")
    end

    xit "can shop, login and checkout" do
      page.find("#ckout_btn").click

      fill_in "session[email_address]", with: "billy@email.com"
      fill_in "session[password]", with: "password"
      click_button "Log In"

      expect(page).to have_content("Logged in as billy@email.com")

      page.find('#cart_button').click
      click_on('cart')

      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      expect(page).to have_content('Thank You For Ordering')

      expect(current_path).to eq("/restaurant/verification")
    end

    xit "can shop, sign up and checkout" do
      page.find("#ckout_btn").click

      expect(page).to have_content("Please log in or create an account")

      fill_in "user[fullname]", with: "Tommy"
      fill_in "user[email_address]", with: "tommy@email.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      fill_in "user[screen_name]", with: "BigTom"
      click_button "Create User"

      expect(page).to have_content("You Have Successfully Created A New Account!")
      expect(page).to have_content("Lasagna")
      expect(page).to have_content(45)

      page.find("#ckout_btn").click
      page.find("#pickup_btn").click
      expect(page).to have_content('Thank You For Ordering')
    end
  end
end
