# Base UAL portal Page Object class definition common to all pages in the portal.

class GenericPortalPage < TestCentricity::PageObject
  trait(:page_name)  { 'UAL Flight Bookings Portal' }

  # common UI elements
  element :portal_busy, 'div.spinner-container'

  # open the UAL web portal for the specified locale
  def open_portal
    # split the specified locale into language and country codes
    current_locale = ENV['LOCALE'] || 'en-US'
    locale = current_locale.split('-')
    language = locale[0]
    country  = locale[1].downcase
    # set the URL append value to include language and country codes
    Environ.current.append = "#{language}/#{country}/"

    super
  end

  # wait until the portal spinning busy indicator object is hidden, or until the specified wait time has expired.
  def wait_not_busy(wait_time)
    portal_busy.wait_until_hidden(wait_time)
  end
end
