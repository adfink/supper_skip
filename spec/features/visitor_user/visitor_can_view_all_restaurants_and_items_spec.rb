require "rails_helper"

feature "any user" do

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


    xit "can see all restaurants" do
      visit root_path

      expect(current_path).to eq('/restaurants')
      expect(page).to have_content("Edible Objects")
      expect(page).to have_content("Olive Garden")
    end

    xit "can visit a restaurants items page and view all items" do
      visit root_path
      click_link "Olive Garden"

      expect(current_path).to eq('/restaurants/olive-garden/items')
      expect(page).to have_content("Lasagna")
      expect(page).to_not have_content("Organic Matter")

      visit root_path
      click_link "Olive Garden"

      expect(current_path).to eq('/restaurants/edible-objects/items')
      expect(page).to have_content("Organic Matter")
      expect(page).to_not have_content("Lasagna")
    end
  end
end
