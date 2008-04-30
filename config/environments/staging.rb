# Settings specified here will take precedence over those in config/environment.rb

ENV['INLINEDIR'] = "/tmp/ruby/"

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
# No, we care if the mailer can't send!
config.action_mailer.raise_delivery_errors = true

# Force this environment to use the "info" logger level 
# (by default production uses :info, the others :debug)
config.log_level = :info

# set a constant so we can test if the app is running on the production server
PRODUCTION_SERVER = false
DEVELOPMENT_SERVER = false
