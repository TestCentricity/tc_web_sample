# Cucumber -d (dry-run) must pass, but support/env.rb is not loaded on dry runs.
# This file contains the same requires from env.rb to allow cucumber -d to pass.

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
