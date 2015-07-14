require "rails_helper"

feature "any user" do

  context "while not signed in" do

    before(:each) do
      restaurant_a = Restaurant.create(name: 'Edible Objects', description: 'Tasty', display_name: "edible")
      restaurant_b = Restaurant.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")
      # category_a = restaurant_a.category.create(name: "Sweets")
      # category_b = restaurant_b.category.create(name: "Pastas")
      item_a = restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
      item_b = restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

      user = User.create!(full_name: 'Billy', screen_name: 'Billy', email_address: 'billy@email.com', password: 'password')
    end


    it "can see all restaurants" do
      visit restaurants_path

      expect(page).to have_content("Edible Objects")
      expect(page).to have_content("Olive Garden")
    end

    it "can visit a restaurants items page and view all items" do
      visit restaurants_path
      click_link "Olive Garden"

      expect(current_path).to eq('/restaurants/olive-garden')
      expect(page).to have_content("Lasagna")
      expect(page).to_not have_content("Organic Matter")

      visit restaurants_path
      click_link "Edible Objects"

      expect(current_path).to eq('/restaurants/edible')
      expect(page).to have_content("Organic Matter")
      expect(page).to_not have_content("Lasagna")
    end
  end
end
