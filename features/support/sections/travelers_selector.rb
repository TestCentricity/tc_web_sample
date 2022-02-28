# Travelers Selector widget is implemented as a PageSection object because it is used on
# both the Flight Booking Home page and the Book A Flight page.

class TravelersSelector < TestCentricity::PageSection
  trait(:section_locator) { 'div#passengerMenuId' }
  trait(:section_name)    { 'Travelers selector' }

  # Travelers selector UI elements
  buttons    clear_all_button:      "button[class*='clearButton']",
             close_button:          "button[class*='atm-c-btn--bare']"
  textfields num_adults_field:      "div[class*='passengers__fieldset']:nth-of-type(1) > div[class*='passengerRow']:nth-of-type(1) input",
             num_seniors_field:     "div[class*='passengers__fieldset']:nth-of-type(1) > div[class*='passengerRow']:nth-of-type(2) input",
             num_infants_field:     "div[class*='passengers__fieldset']:nth-of-type(1) > div[class*='passengerRow']:nth-of-type(3) input",
             num_lap_infants_field: "div[class*='passengers__fieldset']:nth-of-type(1) > div[class*='passengerRow']:nth-of-type(4) input",
             num_child_15_17_field: "div[class*='passengers__fieldset']:nth-of-type(2) > div[class*='passengerRow']:nth-of-type(1) input",
             num_child_12_14_field: "div[class*='passengers__fieldset']:nth-of-type(2) > div[class*='passengerRow']:nth-of-type(2) input",
             num_child_5_11_field:  "div[class*='passengers__fieldset']:nth-of-type(2) > div[class*='passengerRow']:nth-of-type(3) input",
             num_child_2_4_field:   "div[class*='passengers__fieldset']:nth-of-type(2) > div[class*='passengerRow']:nth-of-type(4) input"

  # travelers_data argument is a comma-delimited string, each segment specifying the number and type of traveler(s).
  # Valid traveler type descriptors are:
  #    Adult          or  Adults
  #    Senior         or  Seniors
  #    Child (15-17)  or  Children (15-17)
  #    Child (12-14)  or  Children (12-14)
  #    Child (5-11)   or  Children (5-11)
  #    Child (2-4)    or  Children (2-4)
  #    Infant         or  Infants
  #    Infant on lap  or  Infants on lap
  #
  def select_travelers(travelers_data)
    num_adults_field.wait_until_visible(5)
    clear_all_button.click
    sleep(2)
    total_travelers = 0
    # iterate through each type of traveler specified
    travelers_data.split(', ').each do |travelers|
      # determine number and type of traveler(s)
      segment = travelers.split(' ')
      num_travelers = segment[0].to_i
      segment.delete_at(0)
      type_travelers  = segment.join(' ')
      total_travelers = total_travelers + num_travelers
      # find traveler type object
      traveler_type_obj = case type_travelers.downcase
                          when 'adult', 'adults'
                            num_adults_field
                          when 'senior', 'seniors'
                            num_seniors_field
                          when 'child (15-17)', 'children (15-17)'
                            num_child_15_17_field
                          when 'child (12-14)', 'children (12-14)'
                            num_child_12_14_field
                          when 'child (5-11)', 'children (5-11)'
                            num_child_5_11_field
                          when 'child (2-4)', 'children (2-4)'
                            num_child_2_4_field
                          when 'infant', 'infants'
                            num_infants_field
                          when 'infant on lap', 'infants on lap'
                            num_lap_infants_field
                          else
                            raise "'#{type_travelers}' is not a valid traveler type"
                          end
      # set the number of travelers for the selected traveler type
      traveler_type_obj.set(num_travelers)
    end
    # save the total number of travelers
    FlightSearch.current.total_travelers = total_travelers
    # close the Travelers selector
    close_button.click
    self.wait_until_hidden(5)
  end
end
