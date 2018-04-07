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
    num_adults_field.set('0')
    total_travelers = 0
    travelers_data.split(', ').each do |travelers|
      segment = travelers.split(' ')
      num_travelers  = segment[0]
      type_travelers = segment[1]
      total_travelers = total_travelers + num_travelers.to_i
      case type_travelers.downcase
      when 'adult', 'adults'
        num_adults_field.set(num_travelers)
      when 'senior', 'seniors'
        num_seniors_field.set(num_travelers)
      when 'child (16-17)', 'children (16-17)'
        num_child_16_17_field.set(num_travelers)
      when 'child (12-15)', 'children (12-15)'
        num_child_12_15_field.set(num_travelers)
      when 'child (5-11)', 'children (5-11)'
        num_child_5_11_field.set(num_travelers)
      when 'child (2-4)', 'children (2-4)'
        num_child_2_4_field.set(num_travelers)
      when 'infant', 'infants'
        num_infants_field.set(num_travelers)
      when 'infant on lap', 'infants on lap'
        num_lap_infants_field.set(num_travelers)
      end
    end
    # save the total number of travelers
    FlightSearch.current.total_travelers = total_travelers
    # close the Travelers selector
    close_button.click
    self.wait_until_hidden(5)
  end
end
