require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# config.exceptions_app = self.routes

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DinnerDash
  class Application < Rails::Application
        config.action_mailer.delivery_method = :smtp
        config.action_mailer.smtp_settings = {
          address:              'smtp.mandrillapp.com',
          port:                 '587',
          domain:               'localhost:3000',
          user_name:            "andrewfink8@gmail.com",
          password:             "IBMLp_8xhPFo9VD5CSUxGQ",
          authentication:       'plain',
          enable_starttls_auto: true
        }

        # Do not swallow errors in after_commit/after_rollback callbacks.
        # config.active_record.raise_in_transactional_callbacks = true
  end
end
