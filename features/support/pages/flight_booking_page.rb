# Page Object class definition for the UAL Flight Booking Home page

class FlightBookingPage < GenericPortalPage
  trait(:page_name)      { 'Flight Booking Home' }
  trait(:page_locator)   { 'form#flightSearch' }

  # Flight Booking page UI elements
  radios       roundtrip_radio:    'input#SearchTypeMain_roundTrip',
               one_way_radio:      'input#SearchTypeMain_oneWay'
  elements     flexible_checkbox:  'div.form-row:nth-of-type(3) > div.form-group',
               nonstop_checkbox:   'div.nonstop-only'
  textfields   origin_field:       'input#Origin',
               destination_field:  'input#Destination',
               depart_date_field:  'input#DepartDate',
               return_date_field:  'input#ReturnDate'
  selectlists  month_select:       'div#uniform-months',
               duration_select:    'div#uniform-tripLength',
               cabin_type_select:  'div#uniform-cabinType',
               award_cabin_select: 'select#awardCabinType'
  buttons      travelers_select:   'a#travelers-selector',
               search_button:      'button#flightBookingSubmit'
  sections     travelers_selector: TravelersSelector,
               locale_selector:    LocaleSelector

  # select the search type (either Round trip or One way)
  def select_search_type(search_type)
    case search_type.gsub(/\s+/, '_').downcase.to_sym
    when :round_trip
      roundtrip_radio.select
    when :one_way
      one_way_radio.select
    end
  end

  # enter search criteria and execute search.
  # search_data argument will either contain a hash from data table in scenario, or will be row name
  # of corresponding row in Flight_Searches worksheet in features/test_data/data.xls
  def enter_search_data(search_data)
    # dismiss the Locale Selector modal if it is visible
    locale_selector.dismiss if locale_selector.visible?
    # if search data in scenario data table hash, map the hash to FlightSearch data object
    # else read the search data from corresponding row in Flight_Searches worksheet in data.xls
    search_data.is_a?(Hash) ?
        search = flight_searches.map_search_data(search_data) :
        search = flight_searches.find_search(search_data)
    # parse the departure date into a meaningful date value
    unless search.depart_date.blank?
      depart_date_value = Chronic.parse(search.depart_date)
      depart_date_value = depart_date_value.to_s.format_date_time('%m/%d/%Y')
    end
    # parse the return date into a meaningful date value
    unless search.return_date.blank?
      return_date_value = Chronic.parse(search.return_date)
      return_date_value = return_date_value.to_s.format_date_time('%m/%d/%Y')
    end
    # parse the flex month into a meaningful date value
    unless search.month.blank?
      month_value = Chronic.parse(search.month)
      month_value = month_value.to_s.format_date_time('%B %Y')
    end
    # if search type is specified, select it before entering search criteria
    select_search_type(search.search_type) unless search.search_type.blank?
    # select flexible dates, if specified
    flexible_checkbox.click if search.flexible.to_bool
    # populate the search data fields with their associate search parameters
    fields = { origin_field      => search.origin,
               destination_field => search.destination,
               depart_date_field => depart_date_value,
               return_date_field => return_date_value,
               month_select      => month_value,
               duration_select   => search.duration,
               cabin_type_select => search.cabin_type }
    populate_data_fields(fields)
    # invoke the Travelers selector and make selection(s)
    unless search.travelers.blank?
      travelers_select.click
      travelers_selector.select_travelers(search.travelers)
    end
    # click non-stop checkbox if specified
    nonstop_checkbox.click if search.non_stop.to_bool
    # execute the search
    search_button.click
  end
end
