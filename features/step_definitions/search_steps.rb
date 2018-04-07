
When(/^I select a search type of ([^\"]*)$/) do |search_type|
  flight_booking_page.select_search_type(search_type)
end


When(/^I perform a search using:$/) do |table|
  flight_booking_page.enter_search_data(table.rows_hash)
end


When(/^I perform a search using ([^\"]*)$/) do |row_name|
  flight_booking_page.enter_search_data(row_name)
end


Then(/^I should( not)? see search results on the Flight Search Results page$/) do |negate|
  flight_search_results_page.verify_page_exists
  flight_search_results_page.verify_search_results(!negate)
end
