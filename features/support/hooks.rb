

Before do |scenario|
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



# exclusionary around hooks to prevent running feature/scenario on unsupported browser, devices, or
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
  qualify_browser(:browserstack, 'BrowserStack', scenario, block)
end


# block feature/scenario execution if running against Sauce Labs cloud-hosted service
Around('@!saucelabs') do |scenario, block|
  qualify_browser(:saucelabs, 'SauceLabs', scenario, block)
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
