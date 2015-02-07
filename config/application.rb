require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Luck
  class Application < Rails::Application
    config.to_prepare do
        Devise::SessionsController.layout "full"
        Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application"   : "full" }
        Devise::ConfirmationsController.layout "full"
        Devise::UnlocksController.layout "full"
        Devise::PasswordsController.layout "full"
    end
  end
end
