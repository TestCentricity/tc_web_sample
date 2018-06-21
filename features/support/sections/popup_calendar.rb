# Popup Calendar widget is implemented as a PageSection object because it is used on both the Flight Booking Home page
# and the Book A Flight page for departure and return date selections.

class PopupCalendar < TestCentricity::PageSection
  trait(:section_locator)     { "div#ui-datepicker-div div[class*='ui-datepicker-group-first']" }
  trait(:section_name)        { 'Popup Calendar' }

  # Popup Calendar UI elements
  button   :next_month_button, "a[class*='ui-datepicker-next']"
  label    :month_year_label,  'div.ui-datepicker-title'

  def select_date(date_value)
    #TODO need to add code for making date selections from calendar
  end
end
