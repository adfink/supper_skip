require "rails_helper"
require 'capybara/rails'
require 'capybara/rspec'

feature "Managing orders" do
  describe "as an anonymous @user" do
    it "trying to access the orders page" do
      visit admin_orders_path
      assert page.status_code == 404
    end
  end

  context "as an admin @user" do
    before(:each) do
      @owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', password_confirmation: 'password', screen_name: 'whit')
      @owner2 = User.create(full_name: 'Bobby Brown', email_address: 'bobby@bobby.com', password: 'password', password_confirmation: 'password', screen_name: 'bobby')

      @restaurant_a = owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = owner2.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      # category_a = restaurant_a.category.create(name: "Sweets")
      # category_b = restaurant_b.category.create(name: "Pastas")
      @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirtttttttttasdfasdfasdfasdf', price: 20)
      @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plasticasdfasdfasdfa', price: 25)

      @user = User.create!(full_name: 'Billy', email_address: 'billy@email.com', password: 'password', password_confirmation: 'password', screen_name: 'Billy')

      login_as(@owner1)
    end

    it "can access the orders page for their restaurant" do
      visit restaurants_path(@restaurant_a)
      click_on "View my Restaurant Orders"

      expect(page.current_path).to eq(restaurant_orders_path(@restaurant_a))
    end

    it "cannot access the orders page for someone elses restaurant" do
      visit restaurants_path(@restaurant_b)
      expect(page).to_not have_link("View my Restaurant Orders")

      visit '/restaurants/olive-garden/orders'
      expect(page.current_path).to eq('/')
      expect(page).to have_content("Get lost #{@owner1.full_name}")
    end

    it "viewing orders" do
      paid      = create_order(user_id: @user.id)
      canceled  = create_order(status: "canceled", user_id: @user.id)
      completed = create_order(status: "completed", user_id: @user.id)
      ordered   = create_order(status: "ordered", user_id: @user.id)

      visit admin_orders_path

      within('#orders') do
        expect(page).to have_content paid.status.capitalize
        expect(page).to have_content canceled.status.capitalize
        expect(page).to have_content completed.status.capitalize
        expect(page).to have_content ordered.status.capitalize
      end
    end

    it "viewing paid orders" do
      paid      = create_order(user_id: @user.id)
      canceled  = create_order(status: "canceled", user_id: @user.id)
      completed = create_order(status: "completed", user_id: @user.id)
      ordered   = create_order(status: "ordered", user_id: @user.id)

      visit admin_orders_path
      click_link "Paid (1)"

      within('#shown-orders') do
        expect(page).to     have_content paid.status
        expect(page).not_to have_content canceled.status
        expect(page).not_to have_content completed.status
        expect(page).not_to have_content ordered.status
      end
    end

    it "viewing the paid filter with a paid order" do
      create_order(user_id: @user.id)
      visit admin_orders_path
      expect(page).to have_link "Paid (1)"
    end

    it "viewing the paid filter without a paid order" do
      visit admin_orders_path
      expect(page).to have_link "Paid (0)"
    end

    it "viewing the completed filter with a completed order" do
      create_order(status: 'completed', user_id: @user.id)
      visit admin_orders_path
      expect(page).to have_link "Completed (1)"
    end

    it "viewing the completed filter with a completed order" do
      visit admin_orders_path
      expect(page).to have_link "Completed (0)"
    end

    it "viewing the canceled filter with a canceled order" do
      create_order(status: 'canceled', user_id: @user.id)
      visit admin_orders_path
      expect(page).to have_link "Canceled (1)"
    end

    it "viewing the canceled filter with a canceled order" do
      visit admin_orders_path
      expect(page).to have_link "Canceled (0)"
    end

    it "viewing the ordered filter with a ordered order" do
      create_order(status: 'ordered', user_id: @user.id)
      visit admin_orders_path
      expect(page).to have_link "Ordered (1)"
    end

    it "viewing the ordered filter with a ordered order" do
      visit admin_orders_path
      expect(page).to have_link "Ordered (0)"
    end

    it "clicking all will allow you to view page with all orders again" do
      create_order(status: 'ordered', user_id: @user.id)
      create_order(status: 'ordered', user_id: @user.id)
      user2 = User.create(full_name: 'Jane', email_address: 'jane@example.com', password: '1234', password_confirmation: '1234', role: 'admin')

      create_order(status: 'canceled', user_id: user2.id)
      create_order(user_id: user2.id)
      visit admin_orders_path

      expect(page).to have_link "Ordered (2)"
      expect(page).to have_link "Paid (1)"
      expect(page).to have_link "Canceled (1)"

      click_link('Ordered (2)')

      expect(page).to have_text "John"
      expect(page).to_not have_text "Jane"
      click_link('View All orders')
      expect(page).to have_text "John"
      expect(page).to have_text "Jane"
    end

    it "can change status of order from ordered to cancelled" do
      order = create_order(status: 'ordered', user_id: @user.id)
      visit admin_orders_path
      click_button 'Cancel'
      expect(page).to have_text 'Canceled (1)'
    end
  end
end
