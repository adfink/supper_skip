require "rails_helper"

feature "unregistered user is able to shop items at multiple restaurants" do

  context "while not signed in" do

    before(:each) do
      owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      @category_a = @restaurant_a.categories.create(name: "Sweets")
      @category_b = @restaurant_b.categories.create(name: "Pastas")

      item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
      item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])

      @user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')

      visit restaurant_path(@restaurant_a)
      click_on "add to cart"

      visit restaurant_path(@restaurant_b)
      click_on "add to cart"

      visit '/'
      click_on("Toggle navigation")
      find('#cart').click
    end

    it "can click checkout and get routed to login or sign up" do
      expect(current_path).to eq(cart_path)

      click_on('Checkout')

      expect(current_path).to eq(login_path)

      #TODO Add this flash error: expect(page).to have_content("Please Login or Sign Up first to purchase!")
      expect(page).to have_content("Log In")
      expect(current_path).to eq("/login")
    end

    it "can shop, login, and checkout" do
      expect(current_path).to eq(cart_path)

      click_on('Checkout')

      fill_in "Email address", with: "billy@email.com"
      fill_in "Password", with: "password"
      click_button "Log In"

      #TODO Add this flash error: expect(page).to have_content("Logged in as billy@email.com")

      click_on("Toggle navigation")
      find('#cart').click

      expect(page).to have_content('Lasagna')
      expect(page).to have_content(45)

      click_on('Checkout')
      click_on('Pick Up')

      expect(page).to have_content('Thank You For Ordering')
      expect(current_path).to eq("/verification")
    end

    it "can shop, sign up and checkout" do
      expect(current_path).to eq(cart_path)

      click_on('Checkout')

      #TODO Add this flash error: expect(page).to have_content("Please log in or create an account")

      click_link "Sign up now!"

      fill_in "Full name", with: "Tommy"
      fill_in "Email address", with: "tommy@email.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      fill_in "Screen name", with: "BigTom"
      click_button "Create Account"

      #TODO - Have user log in immediately after sign up
      visit '/login'
      fill_in "Email address", with: "tommy@email.com"
      fill_in "Password", with: "password"
      click_button "Log In"

      click_on("Toggle navigation")
      find('#cart').click

      expect(page).to have_content('Lasagna')
      expect(page).to have_content('Organic Matter')
      expect(page).to have_content(45)

      click_on('Checkout')
      click_on('Pick Up')

      expect(page).to have_content('Thank You For Ordering')
      expect(current_path).to eq("/verification")
    end
  end
end
