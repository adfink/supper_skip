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
    end

    it "cannot access the orders page for someone elses restaurant" do
      visit restaurants_path(@restaurant_a)
      expect(page).to_not have_link("Restaurant Order History")

      visit '/restaurants/edible/orders'
      expect(current_path).to eq('/')
      expect(page).to have_content("get lost, #{@owner2.full_name}!")
    end

    it "viewing in preparation orders" do
      visit restaurant_orders_path(@restaurant_b)

      find('#order_filter_status', :match => :first).find(:xpath, 'option[1]').select_option

      expect(page).to have_content("Out for delivery")

      expect(page).not_to have_content("Completed")
      expect(page).not_to have_content("In preparation")
    end

    xit "viewing the paid filter with a paid order" do
      create_order(user_id: @owner.id)
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Paid (1)"
    end

    xit "viewing the paid filter without a paid order" do
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Paid (0)"
    end

    xit "viewing the completed filter with a completed order" do
      create_order(status: 'completed', user_id: @owner.id)
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Completed (1)"
    end

    xit "viewing the completed filter with a completed order" do
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Completed (0)"
    end

    xit "viewing the canceled filter with a canceled order" do
      create_order(status: 'canceled', user_id: @owner.id)
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Canceled (1)"
    end

    xit "viewing the canceled filter with a canceled order" do
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Canceled (0)"
    end

    xit "viewing the ordered filter with a ordered order" do
      create_order(status: 'ordered', user_id: @owner.id)
      visit restaurant_orders_path(@restaurant_a)
      expect(page).to have_link "Ordered (1)"
    end


    xit "clicking all will allow you to view page with all orders again" do
      create_order(status: 'ordered', user_id: @owner.id)
      create_order(status: 'ordered', user_id: @owner.id)
      user2 = User.create(full_name: 'Jane', email_address: 'jane@example.com', password: '1234', password_confirmation: '1234', role: 'admin')

      create_order(status: 'canceled', user_id: user2.id)
      create_order(user_id: user2.id)
      visit restaurant_orders_path(@restaurant_a)

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

    xit "can change status of order from ordered to cancelled" do
      order = create_order(status: 'ordered', user_id: @owner.id)
      visit restaurant_orders_path(@restaurant_a)
      click_button 'Cancel'
      expect(page).to have_text 'Canceled (1)'
    end
  end
end
