require "rails_helper"

feature "any user is able to see" do

  context "while not signed in" do

    before(:each) do
      owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")

      @category_a = @restaurant_a.categories.create(name: "Sweets")
      @category_b = @restaurant_a.categories.create(name: "Pastas")

      @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20, categories: [@category_a])
      @item_b = @restaurant_a.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25, categories: [@category_b])
    end

    it "clicks on browse button sees a category" do
      visit restaurant_path(@restaurant_a)
      click_on "Sweets"

      expect(page).to have_content("Organic Matter")
      expect(page).to_not have_content("Lasagna")

      visit restaurant_path(@restaurant_a)
      click_on "Pastas"

      expect(page).to_not have_content("Organic Matter")
      expect(page).to have_content("Lasagna")
    end
  end
end
