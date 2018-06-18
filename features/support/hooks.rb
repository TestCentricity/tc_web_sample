
def run_first_once
  # HTML report header information if reporting is enabled
  if ENV['REPORTING']
    report_header = "\n<b><u>TEST ENVIRONMENT</u>:</b> #{ENV['TEST_ENVIRONMENT']}\n"\
      "\n  <b>Browser:</b>\t #{Environ.browser.capitalize}\n"
    report_header = "#{report_header}  <b>Device:</b>\t\t #{Environ.device_name}\n" if Environ.device_name
    report_header = "#{report_header}  <b>Device o/s:</b>\t #{Environ.device_os}\n" if Environ.device_os
    report_header = "#{report_header}  <b>Device type:</b>\t #{Environ.device_type}\n" if Environ.device_type
    report_header = "#{report_header}  <b>Device type:</b>\t #{Environ.driver}\n"
    report_header = "#{report_header}  <b>Language:</b>\t #{ENV['LANGUAGE']}\n" if ENV['LANGUAGE']
    report_header = "#{report_header}  <b>Country:</b>\t #{ENV['COUNTRY']}\n" if ENV['COUNTRY']
    report_header = "#{report_header}\n\n"
    puts report_header
  end
  # start Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && (Environ.driver == :appium || ENV['WEB_BROWSER'] == 'appium')
    $server = TestCentricity::AppiumServer.new
    $server.start
  end
end


at_exit do
  # terminate Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && (Environ.driver == :appium || ENV['WEB_BROWSER'] == 'appium')
    $server.stop
  end
end


Before do |scenario|
  # if executing tests in parallel concurrent threads, print thread number with scenario name
  ENV['PARALLEL'] ?
      message = "Thread ##{ENV['TEST_ENV_NUMBER']} | Scenario:  #{scenario.name}" :
      message = "Scenario:  #{scenario.name}"
  puts message
  $initialized ||= false
  unless $initialized
    $initialized = true
    # if a run first/run once method is defined, call it
    run_first_once if defined? run_first_once
  end
end


After do
  # close Capybara Appium driver if it was opened
  Capybara.page.driver.quit if Capybara.default_driver == :appium
end


# exclusionary Around hooks to prevent running feature/scenario on unsupported browsers, devices, or
# cloud remote browser hosting platforms. Use the following tags to block test execution:
#   desktop web browsers:      @!safari, @!ie, @!firefox, @!chrome, @!edge
#   mobile devices:            @!ipad, @!iphone
#   remotely hosted browsers:  @!browserstack, @!saucelabs

# block feature/scenario execution if running against Safari browser
Around('@!safari') do |scenario, block|
  qualify_browser(:safari, 'Safari', scenario, block)
end


# block feature/scenario execution if running against Internet Explorer browser
Around('@!ie') do |scenario, block|
  qualify_browser(:ie, 'Internet Explorer', scenario, block)
end


# block feature/scenario execution if running against Microsoft Edge browser
Around('@!edge') do |scenario, block|
  qualify_browser(:edge, 'Edge', scenario, block)
end


# block feature/scenario execution if running against Chrome browser
Around('@!chrome') do |scenario, block|
  qualify_browser(:chrome, 'Chrome', scenario, block)
end


# block feature/scenario execution if running against Firefox browser
Around('@!firefox') do |scenario, block|
  qualify_browser(:firefox, 'Firefox', scenario, block)
end


# block feature/scenario execution if running against iPad mobile browser
Around('@!ipad') do |scenario, block|
  qualify_device('ipad', scenario, block)
end


# block feature/scenario execution if running against iPhone mobile browser
Around('@!iphone') do |scenario, block|
  qualify_device('iphone', scenario, block)
end


# block feature/scenario execution if running against Browserstack cloud-hosted service
Around('@!browserstack') do |scenario, block|
  if Capybara.default_driver != :browserstack
    block.call
  else
    puts "Scenario '#{scenario.name}' cannot be executed with the BrowserStack service."
    skip_this_scenario
  end
end


# block feature/scenario execution if running against Sauce Labs cloud-hosted service
Around('@!saucelabs') do |scenario, block|
  if Capybara.default_driver != :saucelabs
    block.call
  else
    puts "Scenario '#{scenario.name}' cannot be executed with the SauceLabs service."
    skip_this_scenario
  end
end


# block feature/scenario execution if running against a physical or emulated mobile device
Around('@!device') do |scenario, block|
  if Environ.is_device?
    puts "Scenario '#{scenario.name}' cannot be executed on physical or emulated devices."
    skip_this_scenario
  else
    block.call
  end
end


Around('@!ios') do |scenario, block|
  if Environ.device_os == :android
    block.call
  else
    puts "Scenario '#{scenario.name}' can not be executed on iOS devices."
    skip_this_scenario
  end
end


Around('@!android') do |scenario, block|
  if Environ.device_os == :ios
    block.call
  else
    puts "Scenario '#{scenario.name}' can not be executed on Android devices."
    skip_this_scenario
  end
end


def qualify_browser(browser_type, browser_name, scenario, block)
  if Environ.browser != browser_type && ENV['HOST_BROWSER'] != browser_name.downcase
    block.call
  else
    puts "Scenario '#{scenario.name}' cannot be executed with the #{browser_name} browser."
    skip_this_scenario
  end
end

def qualify_device(device, scenario, block)
  if Environ.is_device?
    if Environ.device_type.include? device
      puts "Scenario '#{scenario.name}' cannot be executed on #{device} devices."
      skip_this_scenario
    else
      block.call
    end
  else
    block.call
  end
end
