require "rails_helper"
require 'capybara/rails'
require 'capybara/rspec'

feature "Managing orders1" do
  describe "as an anonymous user" do
    it "trying to access the orders1 page" do
      visit admin_orders_path
      assert page.status_code == 404
    end
  end

  context "as an admin user" do
    given!(:user) {
      user = user_with({})
      user.save
      user
    }

    before do
      login_as(user)
    end

    it "trying to access the orders1 page" do
      visit admin_orders_path
      expect(page.current_path).to eq(admin_orders_path)
    end

    it "viewing orders1" do
      paid      = create_order(user_id: user.id)
      canceled = create_order(status: "canceled", user_id: user.id)
      completed = create_order(status: "completed", user_id: user.id)
      ordered   = create_order(status: "ordered", user_id: user.id)

      visit admin_orders_path

      within('#orders1') do
        expect(page).to have_content paid.status.capitalize
        expect(page).to have_content canceled.status.capitalize
        expect(page).to have_content completed.status.capitalize
        expect(page).to have_content ordered.status.capitalize
      end
    end

    it "viewing paid orders1" do
      paid      = create_order(user_id: user.id)
      canceled  = create_order(status: "canceled", user_id: user.id)
      completed = create_order(status: "completed", user_id: user.id)
      ordered   = create_order(status: "ordered", user_id: user.id)

      visit admin_orders_path
      click_link "Paid (1)"

      within('#shown-orders1') do
        expect(page).to     have_content paid.status
        expect(page).not_to have_content canceled.status
        expect(page).not_to have_content completed.status
        expect(page).not_to have_content ordered.status
      end
    end

    it "viewing the paid filter with a paid order" do
      create_order(user_id: user.id)
      visit admin_orders_path
      expect(page).to have_link "Paid (1)"
    end

    it "viewing the paid filter without a paid order" do
      visit admin_orders_path
      expect(page).to have_link "Paid (0)"
    end

    it "viewing the completed filter with a completed order" do
      create_order(status: 'completed', user_id: user.id)
      visit admin_orders_path
      expect(page).to have_link "Completed (1)"
    end

    it "viewing the completed filter with a completed order" do
      visit admin_orders_path
      expect(page).to have_link "Completed (0)"
    end

    it "viewing the canceled filter with a canceled order" do
      create_order(status: 'canceled', user_id: user.id)
      visit admin_orders_path
      expect(page).to have_link "Canceled (1)"
    end

    it "viewing the canceled filter with a canceled order" do
      visit admin_orders_path
      expect(page).to have_link "Canceled (0)"
    end

    it "viewing the ordered filter with a ordered order" do
      create_order(status: 'ordered', user_id: user.id)
      visit admin_orders_path
      expect(page).to have_link "Ordered (1)"
    end

    it "viewing the ordered filter with a ordered order" do
      visit admin_orders_path
      expect(page).to have_link "Ordered (0)"
    end

    it "clicking all will allow you to view page with all orders1 again" do
      create_order(status: 'ordered', user_id: user.id)
      create_order(status: 'ordered', user_id: user.id)
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
      click_link('View All orders1')
      expect(page).to have_text "John"
      expect(page).to have_text "Jane"
    end

    it "can change status of order from ordered to canceled" do
      order = create_order(status: 'ordered', user_id: user.id)
      visit admin_orders_path
      click_button 'Cancel'
      expect(page).to have_text 'Canceled (1)'
    end
  end
end
