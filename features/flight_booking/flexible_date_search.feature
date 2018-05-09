@desktop @mobile @regression @flight @search @flexible_dates


Feature: Search for Flights using Flexible Dates
  In order to find flights that meet my travel itinerary criteria
  As a traveler using the Flight Booking web portal
  I expect to be able to perform basic searches using flexible dates to view flight information


  Background:
    Given I am on the UAL portal


  Scenario Outline: Search for Round Trip flight with flexible dates
    Given I am on the Flight Booking Home page
    When I select a search type of Round Trip
    And I perform a search using:
      | From      | <origin>      |
      | To        | <destination> |
      | Flexible  | Yes           |
      | Month     | <month>       |
      | Duration  | <duration>    |
      | Travelers | <travelers>   |
      | Cabin     | <cabin type>  |
      | Nonstop   | <non stop>    |
    Then I should see search results on the Flight Search Results page

@bat
    Examples:
      | origin  | destination | month             | duration | travelers          | cabin type | non stop |
      | Seattle | San Diego   | 3 months from now | 14 days  | 2 adults, 1 infant | Economy    | No       |

    Examples:
      | origin  | destination | month      | duration | travelers | cabin type        | non stop |
      | PDX     | ORD         | this month | 6 days   | 1 adult   | Business or First | Yes      |
      | DTW     | PHX         | next month | 8 days   | 2 seniors | Economy           | No       |


  Scenario Outline: Search for One Way flight with flexible date
    Given I am on the Flight Booking Home page
    When I select a search type of One Way
    And I perform a search using:
      | From      | <origin>      |
      | To        | <destination> |
      | Flexible  | Yes           |
      | Month     | <month>       |
      | Travelers | <travelers>   |
      | Cabin     | <cabin type>  |
      | Nonstop   | <non stop>    |
    Then I should see search results on the Flight Search Results page

@bat
    Examples:
      | origin  | destination | month      | travelers | cabin type | non stop |
      | DTW     | PHX         | next month | 2 seniors | Economy    | No       |

    Examples:
      | origin  | destination | month             | travelers          | cabin type        | non stop |
      | PDX     | ORD         | this month        | 1 adult            | Business or First | Yes      |
      | Seattle | San Diego   | 2 months from now | 2 adults, 1 infant | Economy           | No       |

@dev
# This is an example of using test data sourced from the Flight_Searches worksheet in /features/support/test_data/data.xls.
# The itinerary_name value is the row_name in the worksheet.
  Scenario Outline: Search for flights with flexible dates using externally sourced data
    Given I am on the Flight Booking Home page
    When I perform a search using <itinerary_name>
    Then I should see search results on the Flight Search Results page

    Examples:
      | itinerary_name |
      | US_US_flexible |
      | CA_CA_flexible |
      | US_UK_flexible |
      | UK_US_flexible |
