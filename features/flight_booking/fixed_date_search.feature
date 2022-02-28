@desktop @mobile @regression @flight @search @fixed_dates


Feature: Search for Flights using Fixed Dates
  In order to find flights that meet my travel itinerary criteria
  As a traveler using the Flight Booking web portal
  I expect to be able to perform basic searches using fixed dates to view flight information


  Background:
    Given I am on the UAL portal
    And I am on the Flight Booking Home page


  Scenario Outline: Search for flight with fixed dates
    When I perform a search using:
      |Search Type |<type>        |
      |From        |<origin>      |
      |To          |<destination> |
      |Flexible    |No            |
      |Depart      |<depart date> |
      |Return      |<return date> |
      |Travelers   |<travelers>   |
      |Cabin       |<cabin type>  |
    Then I should see search results on the Fixed Date Search Results page

@bat
    Examples:
      |type       |origin |destination |depart date      |return date      |travelers |cabin type      |
      |Round trip |PDX    |ORD         |4 weeks from now |5 weeks from now |1 adult   |Economy         |
      |One way    |ORD    |PDX         |3 weeks from now |                 |1 adult   |Premium Economy |

    Examples:
      |type       |origin |destination |depart date       |return date      |travelers          |cabin type        |
      |Round trip |SEA    |SAN         |16 days from now  |24 days from now |2 adults, 1 infant |Economy           |
      |One way    |LAS    |TUS         |2 months from now |                 |2 seniors          |Business or First |


# This is an example of using externally sourced test data from the Flight_Searches worksheet in /config/test_data/data.xls.
# The itinerary_name value is the row_name in the worksheet.
  Scenario Outline: Search for flights with fixed dates using externally sourced data
    When I perform a search using the <itinerary_name> itinerary
    Then I should see search results on the Fixed Date Search Results page

    Examples:
      |itinerary_name |
      |US_CA_fixed    |
      |US_FR_fixed    |


  Scenario Outline: Verify no flights found for search with criteria that cannot be satisfied
    When I perform a search using:
      |Search Type |<type>        |
      |From        |<origin>      |
      |To          |<destination> |
      |Flexible    |No            |
      |Depart      |<depart date> |
      |Return      |<return date> |
      |Travelers   |<travelers>   |
    Then I should not see search results on the Fixed Date Search Results page

    Examples:
      |type       |origin |destination |depart date |return date     |travelers                         |
      |Round trip |EUG    |EVN         |tomorrow    |3 days from now |10 seniors                        |
      |One way    |YWG    |PNK         |today       |                |6 adults, 1 child (2-4), 1 infant |
