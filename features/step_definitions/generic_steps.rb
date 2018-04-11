include TestCentricity


Given(/^I am on the UAL portal$/) do
  # split the specified locale into language and country codes
  current_locale = ENV['LOCALE'] || 'en-US'
  locale = current_locale.split('-')
  language = locale[0]
  country  = locale[1].downcase
  # set the URL append value to include language and country codes
  Environ.current.append = "#{language}/#{country}/"
  # open the UAL web portal for the specified locale
  portal_page.open_portal
end


Given(/^I am (?:on|viewing) the ([^\"]*) page$/) do |page_name|
  # find and load the specified target page
  target_page = page_dispatcher(page_name)
  target_page.load_page if target_page
end


Given(/^I (?:go|navigate) to the ([^\"]*) page$/) do |page_name|
  # find and navigate to the specified target page
  target_page = page_dispatcher(page_name)
  target_page.navigate_to if target_page
  target_page.verify_page_exists
end


Then(/^I should see the ([^\"]*) page$/) do |page_name|
  # find and verify that the specified target page is loaded
  target_page = page_dispatcher(page_name)
  target_page.verify_page_exists if target_page
end


Then(/^I expect the ([^\"]*) page to be correctly displayed$/) do |page_name|
  # find and verify that the specified target page is loaded
  target_page = page_dispatcher(page_name)
  target_page.verify_page_exists
  # verify that target page is correctly displayed
  target_page.verify_page_ui
end


When(/^I (?:access|switch to) the new browser tab$/) do
  Browsers.switch_to_new_browser_instance
end


When(/^I close the current browser window$/) do
  Browsers.close_current_browser_window
  begin
    page.driver.browser.switch_to.alert.accept
    switch_to_new_browser_instance
  rescue
  end
end


When(/^I close the previous browser window$/) do
  Browsers.close_old_browser_instance
end


When(/^I refresh the current page$/) do
  Browsers.refresh_browser unless Environ.driver == :appium
end


When(/^I navigate back$/) do
  Browsers.navigate_back
end


When(/^I navigate forward$/) do
  Browsers.navigate_forward
end


When(/^I set device orientation to ([^\"]*)$/) do |orientation|
  Browsers.set_device_orientation(orientation.downcase.to_sym)
end


def page_dispatcher(page_name)
  page = PageManager.find_page(page_name)
  raise "No page object defined for page named '#{page_name}'" unless page
  page
end
