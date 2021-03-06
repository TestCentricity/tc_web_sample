# Page Object class definition for the UAL Flight Search results page

class FlightSearchResultsPage < GenericPortalPage
  trait(:page_name)        { 'Flight Search Results' }
  trait(:page_locator)     { "body[class*='flight-search-results']" }

  # Flight Booking page UI elements
  textfields  origin_field:           '#Origin',
              destination_field:      '#Destination',
              departure_date_field:   '#DepartDate',
              return_date_field:      '#ReturnDateForEditSearch'
  list        :flight_results_list,   'section#fl-results > div:nth-of-type(1) > ul#flight-result-list-revised:nth-of-type(1)'
  table       :fare_calendar_table,   'table.fare-calendar-price-month'
  labels      error_message_label:    '#gridNearByError > h2',
              nearby_error_message:   '#nearbysearcherrormsg'
  button      :search_nearby_button,  '#searchByNearbyAirport'

  # if search results are expected, found is true. Verify that origin, destination, departure date,
  # and number of travelers is displayed on search results page.
  def verify_search_results(found)
    # wait up to 30 seconds for search busy indicator to disappear
    wait_not_busy(30)
    # search results expected
    if found
      search_data = FlightSearch.current
      # wait for results to be displayed
      if search_data.flexible.to_bool
        fare_calendar_table.wait_until_visible(45)
      else
        flight_results_list.wait_until_visible(45)
      end
      # build hash of objects that are common to all search results
      ui = {
          origin_field         => { visible: true, value: { contains: search_data.origin } },
          destination_field    => { value: { contains: search_data.destination } },
          search_nearby_button => { visible: false },
          error_message_label  => { visible: false }
      }
      # parse the departure date into a meaningful localized date value
      unless search_data.depart_date.blank?
        depart_date_value = search_data.depart_date.to_s.format_date_time(:abbrev)
        ui[departure_date_field] = { visible: true, value: depart_date_value }
      end
      # parse the return date into a meaningful localized date value
      unless search_data.return_date.blank?
        return_date_value = search_data.return_date.to_s.format_date_time(:abbrev)
        ui[return_date_field] = { visible: true, value: return_date_value }
      end
      # verify correct search results lists are displayed
      if search_data.flexible.to_bool
        ui[fare_calendar_table] = { visible: true, rowcount: { greater_than_or_equal: 1 } }
        ui[flight_results_list] = { visible: false }
      else
        ui[flight_results_list] = { visible: true, itemcount: { greater_than_or_equal: 1 } }
        ui[fare_calendar_table] = { visible: false }
      end
      # verify that search results are correctly displayed
      verify_ui_states(ui)
    else
      # no results expected
      error_message_label.wait_until_visible(30)
      ui = {
          error_message_label  => { visible: true, caption: { translate: 'search_results.no_flights_found' } },
          search_nearby_button => { visible: true, caption: { translate: 'search_results.search_nearby' } },
          nearby_error_message => { visible: true, caption: { translate: 'search_results.nearby_search_error' } },
          flight_results_list  => { visible: false }
          }
      # verify that search error message is correctly displayed and translated
      verify_ui_states(ui)
    end
  end
end
