# Travelers Selector widget is implemented as a PageSection object because it is used on
# both the Flight Booking Home page and the Book A Flight page.

class TravelersSelector < TestCentricity::PageSection
  trait(:section_locator)     { 'div#travelers-select' }
  trait(:section_name)        { 'Travelers selector' }

  # Travelers selector UI elements
  button      :close_button,          'button.modalCloseImg.dropdown-close'
  textfields  num_adults_field:       'input#NumOfAdults',
              num_seniors_field:      'input#NumOfSeniors',
              num_child_16_17_field:  'input#NumOfChildren04',
              num_child_12_15_field:  'input#NumOfChildren03',
              num_child_5_11_field:   'input#NumOfChildren02',
              num_child_2_4_field:    'input#NumOfChildren01',
              num_infants_field:      'input#NumOfInfants',
              num_lap_infants_field:  'input#NumOfLapInfants'

  # travelers_data argument is a comma-delimited string, each segment specifying the number and type of traveler(s).
  # Valid traveler type descriptors are:
  #    Adult          or  Adults
  #    Senior         or  Seniors
  #    Child (16-17)  or  Children (16-17)
  #    Child (12-15)  or  Children (12-15)
  #    Child (5-11)   or  Children (5-11)
  #    Child (2-4)    or  Children (2-4)
  #    Infant         or  Infants
  #    Infant on lap  or  Infants on lap
  #
  def select_travelers(travelers_data)
    num_adults_field.wait_until_visible(5)
    num_adults_field.clear
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
      case type_travelers.downcase
      when 'adult', 'adults'
        traveler_type_obj = num_adults_field
      when 'senior', 'seniors'
        traveler_type_obj = num_seniors_field
      when 'child (16-17)', 'children (16-17)'
        traveler_type_obj = num_child_16_17_field
      when 'child (12-15)', 'children (12-15)'
        traveler_type_obj = num_child_12_15_field
      when 'child (5-11)', 'children (5-11)'
        traveler_type_obj = num_child_5_11_field
      when 'child (2-4)', 'children (2-4)'
        traveler_type_obj = num_child_2_4_field
      when 'infant', 'infants'
        traveler_type_obj = num_infants_field
      when 'infant on lap', 'infants on lap'
        traveler_type_obj = num_lap_infants_field
      else
        raise "'#{type_travelers}' is not a valid traveler type"
      end
      # set the number of travelers for the selected traveler type
      traveler_type_obj.clear
      traveler_type_obj.set(num_travelers)
    end
    # save the total number of travelers
    FlightSearch.current.total_travelers = total_travelers
    # close the Travelers selector
    close_button.click
    self.wait_until_hidden(5)
  end
end
