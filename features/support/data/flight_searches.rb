class FlightSearchData < TestCentricity::ExcelDataSource

  WKS_FLIGHT_SEARCHES ||= 'Flight_Searches'

  def find_search(row_name)
    @current = FlightSearch.new(read_excel_row_data(WKS_FLIGHT_SEARCHES, row_name))
    FlightSearch.current = @current
  end

  def map_search_data(search_data)
    @current = FlightSearch.new(search_data)
    FlightSearch.current = @current
  end
end


class FlightSearch < TestCentricity::DataObject
  attr_accessor :search_type
  attr_accessor :origin
  attr_accessor :destination
  attr_accessor :flexible
  attr_accessor :depart_date
  attr_accessor :return_date
  attr_accessor :month
  attr_accessor :duration
  attr_accessor :travelers
  attr_accessor :cabin_type
  attr_accessor :non_stop
  attr_accessor :total_travelers

  def initialize(data)
    @search_type = data['Search Type']
    @origin      = data['From']
    @destination = data['To']
    @flexible    = data['Flexible']
    @depart_date = data['Depart']
    @return_date = data['Return']
    @month       = data['Month']
    @duration    = data['Duration']
    @travelers   = data['Travelers']
    @cabin_type  = data['Cabin']
    @non_stop    = data['Nonstop']
    super
  end
end
