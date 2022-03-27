# Page Object class definition for the UAL Flight Booking Home page

class FlightBookingPage < GenericPortalPage
  trait(:page_name)    { 'Flight Booking Home' }
  trait(:page_locator) { "div[class*='bookerContainer']" }

  # Flight Booking page UI elements
  radios      roundtrip_radio:   'input#roundtrip',
              one_way_radio:     'input#oneway'
  checkbox    :flexible_check,   'input#flexibleDates'
  textfields  origin_field:      'input#bookFlightOriginInput',
              destination_field: 'input#bookFlightDestinationInput',
              depart_date_field: 'input#DepartDate',
              return_date_field: 'input#ReturnDate'
  selectlists month_select:      "div[class*='expandFlexMonth']",
              duration_select:   "div[class*='expandFlexDay']",
              cabin_type_select: "div[class*='bookFlightForm__optionField'] > div[class*='app-components-ListBox']"
  buttons     open_travelers:    "button[class*='passengerButton']",
              search_button:     "button[class*='bookFlightForm__primaryButton']",
              clear_button:      "button[class*='clear']"
  section     :travelers_select, TravelersSelector

  # define the custom element components for selectlist, radio button, and checkbox objects
  def initialize
    super
    # define the custom list element components for the Month, Duration, and Cabin Type selectlist objects
    list_spec = {
      selected_item: "li[aria-selected=true]",
      list_item:     "li[role='option']",
      list_trigger:  "button[role='combobox']",
      options_list:  "ul[role='listbox']"
    }
    month_select.define_list_elements(list_spec)
    duration_select.define_list_elements(list_spec)
    cabin_type_select.define_list_elements(list_spec)
    # define the custom element components for the Round Trip radio button
    radio_spec = { proxy: "label[for='roundtrip']" }
    roundtrip_radio.define_custom_elements(radio_spec)
    # define the custom element components for the One Way radio button
    radio_spec = { proxy: "label[for='oneway']" }
    one_way_radio.define_custom_elements(radio_spec)
    # define the custom element components for the Flexible Date checkbox
    check_spec = { proxy: 'label#flexDatesLabel' }
    flexible_check.define_custom_elements(check_spec)
  end

  # select the search type (either Round Trip or One Way)
  def select_search_type(search_type)
    # select type of search
    case search_type.gsub(/\s+/, '_').downcase.to_sym
    when :round_trip
      roundtrip_radio.select
    when :one_way
      one_way_radio.select
    else
      "#{search_type} is not a valid trip type"
    end
  end

  # enter search criteria and execute search.
  # search_data argument will either contain a hash from a data table in a test scenario, or will be a string
  # containing the row name of a corresponding row in Flight_Searches worksheet in features/test_data/data.xls
  def enter_search_data(search_data)
    # clear existing data from text fields
    clear_field(origin_field)
    clear_field(destination_field)
    clear_field(depart_date_field)
    # if search data in scenario data table hash, map the hash to FlightSearch data object
    # else read the search data from corresponding row in Flight_Searches worksheet in data.xls
    search = search_data.is_a?(Hash) ? flight_searches.map_search_data(search_data) : flight_searches.find_search(search_data)
    # parse the departure date into a meaningful date value
    unless search.depart_date.blank?
      depart_date_value = Chronic.parse(search.depart_date)
      # save the parsed departure date in FlightSearch data object
      FlightSearch.current.depart_date = depart_date_value
      depart_date_value = depart_date_value.to_s.format_date_time(:default)
    end
    # parse the return date into a meaningful date value
    unless search.return_date.blank?
      return_date_value = Chronic.parse(search.return_date)
      # save the parsed return date in FlightSearch data object
      FlightSearch.current.return_date = return_date_value
      return_date_value = return_date_value.to_s.format_date_time(:default)
    end
    # parse the flex month into a meaningful date value
    unless search.month.blank?
      month_value = Chronic.parse(search.month)
      month_value = month_value.to_s.format_date_time(:abbrev_month)
    end
    # select duration if specified - use option value since option text will be localized
    unless search.duration.blank?
      number_of_days = search.duration.split(' ')
      number_of_days = {value: number_of_days[0]}
    end
    # select cabin type if specified - use option value since option text will be localized
    unless search.cabin_type.blank?
      cabin_value = case search.cabin_type.gsub(/\s+/, '_').downcase.to_sym
                    when :economy
                      1
                    when :premium_economy
                      2
                    when :business_or_first
                      3
                    else
                      "#{search.cabin_type} is not a valid cabin type"
                    end
      cabin_value = {index: cabin_value}
    end
    # if search type is specified, select it before entering search criteria
    select_search_type(search.search_type) unless search.search_type.blank?
    # populate the search data fields with their associated search parameters
    fields = {
      flexible_check    => search.flexible,
      origin_field      => search.origin,
      destination_field => search.destination,
      month_select      => month_value,
      duration_select   => number_of_days,
      cabin_type_select => cabin_value,
      depart_date_field => depart_date_value,
      return_date_field => return_date_value
    }
    populate_data_fields(fields)
    # invoke the Travelers selector and make selection(s)
    unless search.travelers.blank?
      open_travelers.click
      travelers_select.select_travelers(search.travelers)
    end
    # execute the search
    search_button.click
  end

  # clear existing data from specified text field using associated Clear button
  def clear_field(field_object)
    return if field_object.hidden?

    field_object.click
    clear_button.wait_until_visible(1, post_exception = false)
    clear_button.click if clear_button.visible?
  end
end
