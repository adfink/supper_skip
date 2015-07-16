# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

module MyHelpers
  def user_with(overrides = {})
    attributes = {
      full_name: "John",
      email_address: 'admin@example.com',
      password: '1234',
      password_confirmation: "1234",
      role: 'admin'
    }.merge(overrides)
    User.new(attributes)
  end

  def create(user)
    user.save
    user
  end

  def login_as(user)
    visit login_path
    page.fill_in('Email address', with: user.email_address)
    page.fill_in('Password', with: user.password)
    page.click_button('Log In')
  end

  def create_order(user)
    login_as(user)

  end

  def create_item(overrides = {})
    attributes = {
      name: "Mountain Mud Pie",
      description: "yummy, yummy, yummy, yummy, yummy",
      price: 3.50,
      status: 'active'
    }.merge(overrides)
    Item.create(attributes)
  end

  def create_category(overrides = {})
    attributes = {
      name: "Desserts"
    }.merge(overrides)
    Category.create(attributes)
  end

  def create_item_associated_with_a_category
    appetizer = Category.create(name: 'Appetizers')
    attributes = {
      name: 'dandelion salad',
      description: 'yummy yummy',
      price: 5.00,
      status: 'active',
      category_ids: [appetizer.id]}
    item = Item.create(attributes)
  end

  def create_order_with_order_item(user)
    create_item_associated_with_a_category
    order = Order.create(user_id: user.id, status: "paid")
    order.order_items.create(item_id: Item.last.id, quantity: 3)
  end

  def create_order(overrides = {})
    attributes = {
      user_id: 1,
      status: 'paid'
    }.merge(overrides)
    Order.create(attributes)
  end

end

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!


RSpec.configure do |config|
  config.include(MyHelpers)

   config.before(:suite) do
     DatabaseCleaner.clean_with(:truncation)
   end

   config.before(:each) do
     DatabaseCleaner.strategy = :transaction
   end

   config.before(:each) do
     DatabaseCleaner.start
   end

   config.after(:each) do
     DatabaseCleaner.clean
   end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
