require "rails_helper"

feature "any user is able to see" do
  context "while not signed in" do
    before(:each) do
      restaurant_a = Restaurants.new(name: 'Edible Objects', description: 'Tasty')
      restaurant_b = Restaurants.new(name: 'Olive Garden', description: 'Authentic Italian')
      # category_a = restaurant_a.category.create(name: "Sweets")
      # category_b = restaurant_b.category.create(name: "Pastas")
      item_a = restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
      item_b = restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

      user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')
    end

    xit "can add items to a cart" do
      visit restaurant_path(restaurant_a)
      click_on "Edible Objects"
      click_on "add to cart"

      visit restaurant_path(restaurant_b)
      click_on "Olive Garden"
      click_on "add to cart"

      page.find('#cart_button').click
      click_on('cart')

      expect(page).to have_content("Organic Matter")
      expect(page).to have_content("Lasagna")
      expect(page).to have_content(45)
    end

    xit "can delete an item from cart" do
      visit restaurant_path(restaurant_a)
      click_on "Edible Objects"
      click_on "add to cart"

      page.find('#cart_button').click
      click_on('cart')

      expect(page).to have_content("Organic Matter")
      expect(page).to have_content(20)
      click_link "Remove"

      expect(page).to_not have_content("Organic Matter")
      expect(page).to_not have_content(20)
    end

    xit "can change quantity of item in cart" do
      visit restaurant_path(restaurant_a)
      click_on "Edible Objects"
      click_on "add to cart"
      click_on "add to cart"

      page.find('#cart_button').click
      click_on('cart')

      expect(page).to have_content("Organic Matter")
      expect(page).to have_no_content("Lasagna")
      expect(page).to have_content(40)

      page.find('#quantity').click
      fill_in "1"

      expect(page).to have_content(20)

    end
  end
end
