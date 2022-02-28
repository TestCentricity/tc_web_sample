class FlightSearchData < TestCentricity::ExcelDataSource

  WKS_FLIGHT_SEARCHES ||= 'Flight_Searches'

  def find_search(row_name)
    # for demo purposes, users can select one of the three data sources - Excel .xls, .yml, or .json. In normal practice,
    # you would design your tests to use only one data source and specify that source_type parameter as a symbol (:excel,
    # :yaml, or :json) when calling environs.find_environ in your env.rb file.
    #
    # instead of the case statement, you would either call read_excel_row_data (for Excel .xls file based data source) or
    # environs.read (for .yml or .json based data source).
    search_data = case ENV['DATA_SOURCE'].downcase.to_sym
                  when :excel
                    read_excel_row_data(WKS_FLIGHT_SEARCHES, row_name)
                  when :yaml, :json
                    environs.read(WKS_FLIGHT_SEARCHES, row_name)
                  else
                    raise "#{ENV['DATA_SOURCE']} is not a valid data source"
                  end
    FlightSearch.current = FlightSearch.new(search_data)
  end

  def map_search_data(search_data)
    FlightSearch.current = FlightSearch.new(search_data)
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
    @search_type = data['Search Type'] || data['Search_Type']
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
