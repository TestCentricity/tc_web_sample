# Page Object class definition for the UAL Flexible Date Search Results page

class FlexDateResultsPage < GenericPortalPage
  trait(:page_name)    { 'Flexible Date Search Results' }
  trait(:page_locator) { "body[class*='flight-search-results']" }

  # Flexible Date Search Results page UI elements
  textfields origin_field:      'input#Origin',
             destination_field: 'input#Destination'

  # if search results are expected, found is true. Verify that origin, destination, departure date,
  # and number of travelers is displayed on search results page.
  def verify_search_results(_found)
    # wait up to 30 seconds for search busy indicator to disappear
    wait_not_busy(30)
    # search results expected
    # verification is limited to verifying that origin and destination airport data is displayed
    search_data = FlightSearch.current
    ui = {
      origin_field      => { visible: true, value: { contains: search_data.origin } },
      destination_field => { value: { contains: search_data.destination } },
    }
    # verify search results are correctly displayed
    verify_ui_states(ui)
  end
end
