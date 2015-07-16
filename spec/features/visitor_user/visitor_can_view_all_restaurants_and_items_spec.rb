require "rails_helper"

feature "any user" do

  context "while not signed in" do

    before(:each) do
      owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner1.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      @category_a = @restaurant_a.categories.create(name: "Sweets")
      @category_b = @restaurant_b.categories.create(name: "Pastas")

      item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
      item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])
    end


    it "can see all restaurants" do
      visit restaurants_path

      expect(page).to have_content("Edible Objects")
      expect(page).to have_content("Olive Garden")
    end

    it "can visit a restaurants items page and view all items" do
      visit restaurants_path
      first(:button, "Shop!").click

      expect(current_path).to eq('/restaurants/edible')
      expect(page).to have_content("Organic Matter")
      expect(page).to_not have_content("Lasagna")

      visit restaurant_path(@restaurant_b)

      expect(current_path).to eq('/restaurants/olive-garden')
      expect(page).to have_content("Lasagna")
      expect(page).to_not have_content("Organic Matter")
    end
  end
end
