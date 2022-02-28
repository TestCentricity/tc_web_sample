module WorldPages
  #
  #  page_objects method returns a hash table of your web app's page objects and associated page classes to be instantiated
  # by the TestCentricity™ PageManager. Page Object class definitions are contained in the features/support/pages folder.
  #
  def page_objects
    {
      portal_page:             GenericPortalPage,
      flight_booking_page:     FlightBookingPage,
      fixed_date_results_page: FixedDateResultsPage,
      flex_date_results_page:  FlexDateResultsPage
    }
  end
end


World(WorldPages)
