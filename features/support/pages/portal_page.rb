# Base UAL portal Page Object class definition common to all pages in the portal.

class GenericPortalPage < TestCentricity::PageObject
  trait(:page_name)  { 'UAL Flight Bookings Portal' }

  # common UI elements
  element  :portal_busy,         'div.spinner-container'
  link     :change_locale_link,  'a#change-language-pos'

  # Wait until the portal spinning busy indicator object is hidden, or until the specified wait time has expired.
  #
  # @param wait_time [Integer or Float] wait time in seconds
  #
  def wait_not_busy(wait_time)
    portal_busy.wait_until_hidden(wait_time)
  end
end
