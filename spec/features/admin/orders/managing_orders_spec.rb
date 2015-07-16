require "rails_helper"
require 'capybara/rails'
require 'capybara/rspec'

describe 'Managing orders', type: :feature do
  context "as an admin owner" do
    before(:each) do
      @user = User.create(full_name: "Justin", email_address: "asdf@asdf.com", password: "password")

      @owner1 = User.create(full_name: "Whitney Houston", email_address: "whit@whit.com", password: "password", screen_name: "whit")
      @owner2 = User.create(full_name: "Justin Timberlake", email_address: "justin@justin.com", password: "password", screen_name: "justin")

      @restaurant_a = @owner1.restaurants.create(name: 'Edible Objects', description: 'Tasty', display_name:"edible")
      @restaurant_b = @owner2.restaurants.create(name: 'Olive Garden', description: 'Authentic Italian', display_name: "olive-garden")

      @category_a = @restaurant_a.categories.create(name: "Sweets")
      @category_b = @restaurant_b.categories.create(name: "Pastas")

      @item_a = @restaurant_a.items.create(name: 'Organic Matter', description: 'Real good dirt', price: 20, categories: [@category_a])
      @item_b = @restaurant_b.items.create(name: 'Lasagna', description: 'Definitely not made of plastic', price: 25, categories: [@category_b])

      @admin = Role.create(name: 'admin')
      @cook = Role.create(name: 'cook')
      @dp = Role.create(name: 'delivery person')
      user_role = UserRole.create(user_id: @owner2.id, restaurant_id: @restaurant_b.id, role_id: @admin.id)
      # @owner2.user_roles << user_role

      @online_order = @user.online_orders.create
      order_item = OrderItem.new(order_id: 1, item_id: @item_a.id, quantity: 3 )

      @cancelled_order = Order.create(order_items: [order_item], restaurant_id: @restaurant_a.id, user_id: @user.id, online_order_id: @online_order.id, status: :cancelled)
      @in_prep_order = Order.create(order_items: [order_item], restaurant_id: @restaurant_a.id, user_id: @user.id, online_order_id: @online_order.id, status: :in_preparation)
      @out_for_delivery_order = Order.create(order_items: [order_item], restaurant_id: @restaurant_b.id, user_id: @user.id, online_order_id: @online_order.id, status: :out_for_delivery)
      @completed_order = Order.create(order_items: [order_item], restaurant_id: @restaurant_b.id, user_id: @user.id, online_order_id: @online_order.id, status: :completed)

      login_as(@owner2)
    end
    # @online_order = OnlineOrder.create(user_id: @owner2.id)
    # @order = Order.create(user_id: @owner2.id, status: :ready_for_preparation)
    # @order.order_items.create(item_id: @item_b.id, quantity: 5)

    it "can access the orders page for their restaurant" do
      visit restaurant_path(@restaurant_b)

      click_on "Restaurant Order History"

      expect(page.current_path).to eq(restaurant_orders_path(@restaurant_b))
      assert 1, @owner2.online_orders.count
      expect(page).to have_content("Out for delivery")
      expect(page).to have_content("Completed")
      expect(page).not_to have_content("In preparation")
    end

    it "cannot access the orders page for someone elses restaurant" do
      visit restaurants_path(@restaurant_a)
      expect(page).to_not have_link("Restaurant Order History")

      visit '/restaurants/edible/orders'
      expect(current_path).to eq('/')
      expect(page).to have_content("get lost, #{@owner2.full_name}!")
    end

    xit "can filter orders by status" do
      visit restaurant_orders_path(@restaurant_b)
      find('#order_filter_status').find(:xpath, 'option[1]').select_option
      expect(page).to have_content("Out for delivery")
      expect(page).not_to have_content("Completed")
      expect(page).not_to have_content("In preparation")
    end
  end
end
