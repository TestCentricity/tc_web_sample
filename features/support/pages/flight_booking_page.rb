# Page Object class definition for the UAL Flight Booking Home page

class FlightBookingPage < GenericPortalPage
  trait(:page_name)      { 'Flight Booking Home' }
  trait(:page_locator)   { "body[class*='homepage']" }

  # Flight Booking page UI elements
  labels       roundtrip_label:    "label[for='SearchTypeMain_roundTrip']",
               one_way_label:      "label[for='SearchTypeMain_oneWay']"
  radio        :roundtrip_radio,   '#SearchTypeMain_roundTrip', :roundtrip_label
  radio        :one_way_radio,     '#SearchTypeMain_oneWay', :one_way_label
  elements     mobile_app_banner:  "div[class*='app-banner-wrapper']",
               search_form:        'form#flightSearch',
               book_travel_tile:   'div#tile-book-travel',
               flexible_checkbox:  'div.form-row:nth-of-type(3) > div.form-group',
               nonstop_checkbox:   'div.nonstop-only'
  textfields   origin_field:       '#Origin',
               destination_field:  '#Destination',
               depart_date_field:  '#DepartDate',
               return_date_field:  '#ReturnDate'
  selectlists  month_select:       '#uniform-months',
               duration_select:    '#uniform-tripLength',
               cabin_type_select:  '#uniform-cabinType'
  buttons      app_banner_close:   'div.mw-ab-close',
               travelers_select:   '#travelers-selector',
               search_button:      '#flightBookingSubmit'
  sections     calendar_popup:     PopupCalendar,
               travelers_selector: TravelersSelector

  # make sure the Search form is visible
  def open_search_form
    # dismiss the Locale Selector modal if it is visible
    locale_selector.dismiss if locale_selector.visible?

    # dismiss mobile app banner if visible
    app_banner_close.click if mobile_app_banner.visible?

    # click the Book Travel tile if the Search form is not visible
    unless search_form.visible?
      book_travel_tile.click
      search_form.wait_until_visible(5)
    end
  end

  # select the search type (either Round Trip or One Way)
  def select_search_type(search_type)
    # make sure Search form is visible
    open_search_form
    # select type of search
    case search_type.gsub(/\s+/, '_').downcase.to_sym
    when :round_trip
      roundtrip_radio.select
    when :one_way
      one_way_radio.select
    end
  end

  # enter search criteria and execute search.
  # search_data argument will either contain a hash from a data table in a test scenario, or will be a string
  # containing the row name of a corresponding row in Flight_Searches worksheet in features/test_data/data.xls
  def enter_search_data(search_data)
    # make sure Search form is visible
    open_search_form

    # if search data in scenario data table hash, map the hash to FlightSearch data object
    # else read the search data from corresponding row in Flight_Searches worksheet in data.xls
    search_data.is_a?(Hash) ?
        search = flight_searches.map_search_data(search_data) :
        search = flight_searches.find_search(search_data)

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
      month_value = month_value.to_s.format_date_time(:month_year)
    end

    # if search type is specified, select it before entering search criteria
    select_search_type(search.search_type) unless search.search_type.blank?

    # select flexible dates, if specified
    flexible_checkbox.click if search.flexible.to_bool

    if depart_date_field.visible? && depart_date_field.read_only?
      # populate the origin and destination fields with their associated search parameters
      fields = {
          origin_field      => search.origin,
          destination_field => search.destination
      }
      populate_data_fields(fields)
      # enter departure and return dates using the popup calendar
      depart_date_field.click unless calendar_popup.visible?
      calendar_popup.select_date(depart_date_value)
      return_date_field.click unless calendar_popup.visible?
      calendar_popup.select_date(return_date_value)
    else
      # populate the search data fields with their associated search parameters
      fields = {
          origin_field      => search.origin,
          destination_field => search.destination,
          depart_date_field => depart_date_value,
          return_date_field => return_date_value,
          month_select      => month_value
      }
      populate_data_fields(fields)
    end

    # tab out of departure date field if the popup calendar remains visible
    if calendar_popup.visible? && Environ.browser != :safari
      depart_date_field.send_keys(:tab)
      calendar_popup.wait_until_gone(5)
      sleep(1)
    end

    # invoke the Travelers selector and make selection(s)
    unless search.travelers.blank?
      travelers_select.click
      travelers_selector.select_travelers(search.travelers)
    end

    # select duration if specified - use option value since option text will be localized
    unless search.duration.blank?
      number_of_days = search.duration.split(' ')
      duration_select.choose_option(value: number_of_days[0])
    end

    # select cabin type if specified - use option value since option text will be localized
    unless search.cabin_type.blank?
      case search.cabin_type.downcase
      when 'economy'
        cabin_value = 'econ'
      when 'business or first'
        cabin_value = 'businessFirst'
      end
      cabin_type_select.choose_option(value: cabin_value)
    end

    # click non-stop checkbox if specified
    nonstop_checkbox.click if search.non_stop.to_bool

    # execute the search
    search_button.click
  end
end
