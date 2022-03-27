# Page Object class definition for the UAL Fixed Date Search Results page

class FixedDateResultsPage < GenericPortalPage
  trait(:page_name)    { 'Fixed Date Search Results' }
  trait(:page_locator) { "div[class*='FlightSearchResultsContainer']" }

  # Fixed Date Search Results page UI elements
  list   :flight_results_list,   "div[class*='ResultGrid'][role='grid']"
  labels depart_value:           "div[class*='flightRow']:nth-of-type(1) div[class*='departAirport'] > div > span:nth-of-type(1)",
         arrive_value:           "div[class*='flightRow']:nth-of-type(1) div[class*='arrivalAirport'] > div > span:nth-of-type(1)",
         no_flights_found_label: "div[class*='FlightSearchResultsContainer'] h2",
         search_nearby_message:  "div[class*='CoverImageCard']:nth-of-type(1) div[class*='CoverImageCard-styles__title']"
  button :search_nearby_button,  "div[class*='CoverImageCard']:nth-of-type(1) button[class*='atm-c-btn--secondary']"

  # define the custom list element components for the Fixed Date Search results list objects
  def initialize
    super
    flight_results_list.define_list_elements(list_item: "div[class*='flightRow']")
  end

  # if search results are expected, found is true. Verify that origin, destination, departure date,
  # and number of travelers is displayed on search results page.
  def verify_search_results(found)
    # wait up to 30 seconds for search busy indicator to disappear
    wait_not_busy(30)
    # search results expected
    ui = if found
           search_data = FlightSearch.current
           # wait for results to be displayed
           flight_results_list.wait_until_visible(45)
           # verify that search results are correctly displayed
           # verification is limited to determining that at least one row of data is returned in the flight results list,
           # and that the origin and destination airport data is displayed in the first result
           {
             flight_results_list => { visible: true, itemcount: { greater_than_or_equal: 1 } },
             depart_value        => { visible: true, caption: search_data.origin },
             arrive_value        => { visible: true, caption: search_data.destination }
           }
         else
           # no results expected
           search_nearby_button.wait_until_visible(30)
           {
             no_flights_found_label => { visible: true, caption: { translate: 'search_results.no_flights_found' } },
             search_nearby_button   => { visible: true, caption: { translate: 'search_results.search' } },
             search_nearby_message  => { visible: true, caption: { translate: 'search_results.search_nearby' } },
             flight_results_list    => { visible: false }
           }
         end
    # verify search results are correctly displayed
    verify_ui_states(ui)
  end
end
