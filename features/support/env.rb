require 'capybara/cucumber'
require 'testcentricity_web'
require 'parallel_tests'
require 'appium_capybara'
require 'require_all'
require 'pry'

require_relative 'world_data'
require_relative 'world_pages'

require_rel 'data'
require_rel 'sections'
require_rel 'pages'

# set Capybara's default max wait time to 20 seconds
Capybara.default_max_wait_time = 20

# set the default locale and auto load all translations from features/support/locales/*.rb,yml.
ENV['LOCALE'] = 'en-US' unless ENV['LOCALE']
I18n.load_path += Dir['features/support/locales/*.{rb,yml}']
I18n.default_locale  = ENV['LOCALE']
Faker::Config.locale = ENV['LOCALE']

# instantiate all data objects
include WorldData
WorldData.instantiate_data_objects

# instantiate all page objects
include WorldPages
WorldPages.instantiate_page_objects

# set the WebDriver path for locally hosted Chrome, Firefox, or IE browsers
TestCentricity::WebDriverConnect.set_webdriver_path(File.absolute_path('../..', File.dirname(__FILE__)))

# establish connection to WebDriver, target web browser, and target test environment
environs.find_environ(ENV['TEST_ENVIRONMENT'], :excel)
TestCentricity::WebDriverConnect.initialize_web_driver
