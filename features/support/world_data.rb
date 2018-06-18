module WorldData
  #
  #  data_objects method returns a hash table of your web app's data objects and associated data object classes to be instantiated
  #  by the TestCentricity™ DataManager. Data Object class definitions are contained in the features/support/data folder.
  #
  def data_objects
    { flight_searches: FlightSearchData }
  end
end


World(WorldData)
