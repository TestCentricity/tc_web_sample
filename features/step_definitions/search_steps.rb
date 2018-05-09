
When(/^I select a search type of ([^\"]*)$/) do |search_type|
  flight_booking_page.select_search_type(search_type)
end


When(/^I perform a search using:$/) do |table|
  flight_booking_page.enter_search_data(table.rows_hash)
end


When(/^I perform a search using ([^\"]*)$/) do |row_name|
  flight_booking_page.enter_search_data(row_name)
end


Then(/^I should( not)? see search results on the ([^\"]*) page$/) do |negate, page_name|
  # find and verify that the specified target page is loaded
  target_page = PageManager.find_page(page_name)
  target_page.verify_page_exists
  target_page.verify_search_results(!negate)
end
