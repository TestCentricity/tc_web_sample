@desktop @regression @flight @search @flexible_dates


Feature: Search for Flights using Flexible Dates
  In order to find flights that meet my travel itinerary criteria
  As a traveler using the Flight Booking web portal
  I expect to be able to perform basic searches using flexible dates to view flight information


  Background:
    Given I am on the UAL portal
    And I am on the Flight Booking Home page


  Scenario Outline: Search for flight with flexible dates
    When I perform a search using:
      |Search Type |<type>        |
      |From        |<origin>      |
      |To          |<destination> |
      |Flexible    |Yes           |
      |Month       |<month>       |
      |Duration    |<duration>    |
      |Travelers   |<travelers>   |
      |Cabin       |<cabin type>  |
    Then I should see search results on the Flexible Date Search Results page

@bat
    Examples:
      |type       |origin  |destination |month             |duration |travelers          |cabin type |
      |Round trip |SEA     |SAN         |3 months from now |14 days  |2 adults, 1 infant |Economy    |
      |One way    |DTW     |PHX         |6 weeks from now  |         |2 seniors          |Economy    |

    Examples:
      |type       |origin  |destination |month             |duration |travelers          |cabin type        |
      |Round trip |PDX     |ORD         |this month        |6 days   |1 adult            |Business or First |
      |One way    |SEA     |SAN         |2 months from now |         |2 adults, 1 infant |Economy           |


# This is an example of using test data sourced from the Flight_Searches worksheet in /config/test_data/data.xls.
# The itinerary_name value is the row_name in the worksheet.
  Scenario Outline: Search for flights with flexible dates using externally sourced data
    When I perform a search using the <itinerary_name> itinerary
    Then I should see search results on the Flexible Date Search Results page

    Examples:
      |itinerary_name |
      |US_US_flexible |
      |US_CA_flexible |
