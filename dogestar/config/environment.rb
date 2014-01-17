# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Dogestar::Application.initialize!

config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors = true
config.action_mailer.default_options = {from: 'no-replay@example.com'}