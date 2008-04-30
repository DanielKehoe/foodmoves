# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
ENV['INLINEDIR'] = "/tmp/ruby/"



Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )
  
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # DK enabled 9/21/07 for deployment at Engine Yard
  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

ASSET_IMAGE_PROCESSOR = :image_science || :rmagick || :none

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile
Mime::Type.register 'text/csv', :csv, %w('text/comma-separated-values')

# Include your application configuration below

# From Caboose
# ExceptionNotifier.exception_recipients = %w( support@foodmoves.com )

# From Caboose: cool AR logging hack
require 'ar_extensions'

# DK added 5/4/07 to require Bruce William's paginator gem
require 'paginator'

# derived from example at 
# http://www.iamstillalive.net/notes/2007/04/has_many_through_with_has_many_polymorphs
require 'activerecord_base_phone_extensions'

# DK added 8/8/07 to force all normal Ruby and Rails operations to consistently use UTC
ActiveRecord::Base.default_timezone = :utc
ENV['TZ'] = 'UTC'

# DK modified 9/21/07 for deployment at Engine Yard
# ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :domain             => "foodmoves.com",
  :perform_deliveries => true,
  :address            => 'smtp.ey01.engineyard.com',
  :port               => 25 }
  
# DK added 3/26/08 to use ActionMailer::ARMailer for sending email
require 'action_mailer/ar_mailer'

# DK modified 3/26/08 to use ActionMailer::ARMailer for sending email
ActionMailer::Base.delivery_method = :activerecord
  
# DK added 01/11/2007
# Included Globalize so that we can use Locale.set instead of Globablize::Locale.set
# Set the base language
# Define enviornment variable for DEFAULT_LOCALE
include Globalize
Locale.set_base_language 'en-US'
DEFAULT_LOCALE = 'en-US'

# DK added 6/5/07 as suggested by Stuart Rackham's Rails Date Kit at
# http://www.methods.co.nz/rails_date_kit/rails_date_kit.html
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => '%d %b %Y')

  # These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
  GeoKit::DEFAULT_UNITS = :miles
  GeoKit::DEFAULT_FORMULA = :sphere

  # This is your yahoo application key for the Yahoo Geocoder.
  # See http://developer.yahoo.com/faq/index.html#appid
  # and http://developer.yahoo.com/maps/rest/V1/geocode.html
  GeoKit::Geocoders::YAHOO='X3Jip2DV34FloA843HR8__2UjFyFnPtcn55j9o1Dfsdkeje4JyQHQvveYgQu7mS3'

  # This is your Google Maps geocoder key. 
  # See http://www.google.com/apis/maps/signup.html
  # and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
  # (for use with the YM4R/GM plugin, obtain the Google Maps geocoder key 
  # from the gmaps_api_key.yml file)
  GeoKit::Geocoders::GOOGLE= Ym4r::GmPlugin::ApiKey::GMAPS_API_KEY

  # This is your username and password for geocoder.us.
  # To use the free service, the value can be set to nil or false.  For 
  # usage tied to an account, the value should be set to username:password.
  # See http://geocoder.us
  # and http://geocoder.us/user/signup
  GeoKit::Geocoders::GEOCODER_US=false 

  # This is your authorization key for geocoder.ca.
  # To use the free service, the value can be set to nil or false.  For 
  # usage tied to an account, set the value to the key obtained from
  # Geocoder.ca.
  # See http://geocoder.ca
  # and http://geocoder.ca/?register=1
  GeoKit::Geocoders::GEOCODER_CA=false

  # This is the order in which the geocoders are called in a failover scenario
  # If you only want to use a single geocoder, put a single symbol in the array.
  # Valid symbols are :google, :yahoo, :us, and :ca.
  # Be aware that there are Terms of Use restrictions on how you can use the 
  # various geocoders.  Make sure you read up on relevant Terms of Use for each
  # geocoder you are going to use.
  GeoKit::Geocoders::PROVIDER_ORDER=[:google,:yahoo,:us]
