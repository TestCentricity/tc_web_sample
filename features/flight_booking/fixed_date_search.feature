@desktop @mobile @regression @flight @search @fixed_dates


Feature: Search for Flights using Fixed Dates
  In order to find flights that meet my travel itinerary criteria
  As a traveler using the Flight Booking web portal
  I expect to be able to perform basic searches using fixed dates to view flight information


  Background:
    Given I am on the UAL portal


  Scenario Outline: Search for Round Trip flight with fixed dates
    Given I am on the Flight Booking Home page
    When I select a search type of Round Trip
    And I perform a search using:
      | From      | <origin>      |
      | To        | <destination> |
      | Flexible  | No            |
      | Depart    | <depart date> |
      | Return    | <return date> |
      | Travelers | <travelers>   |
      | Cabin     | <cabin type>  |
      | Nonstop   | <non stop>    |
    Then I should see search results on the Flight Search Results page

@bat
    Examples:
      | origin | destination | depart date      | return date      | travelers | cabin type        | non stop |
      | PDX    | ORD         | 2 weeks from now | 3 weeks from now | 1 adult   | Business or First | Yes      |

    Examples:
      | origin  | destination | depart date      | return date      | travelers          | cabin type | non stop |
      | Seattle | San Diego   | 10 days from now | 14 days from now | 2 adults, 1 infant | Economy    | No       |
      | DTW     | PHX         | 1 week from now  | 12 days from now | 2 seniors          | Economy    | No       |


  Scenario Outline: Search for One Way flight with fixed date
    Given I am on the Flight Booking Home page
    When I select a search type of One Way
    And I perform a search using:
      | From      | <origin>      |
      | To        | <destination> |
      | Flexible  | No            |
      | Depart    | <depart date> |
      | Travelers | <travelers>   |
      | Cabin     | <cabin type>  |
      | Nonstop   | <non stop>    |
    Then I should see search results on the Flight Search Results page

@bat
    Examples:
      | origin | destination | depart date      | travelers | cabin type        | non stop |
      | ORD    | PDX         | 2 weeks from now | 1 adult   | Business or First | Yes      |

    Examples:
      | origin  | destination | depart date      | travelers          | cabin type | non stop |
      | Calgary | San Antonio | 10 days from now | 2 adults, 1 infant | Economy    | No       |
      | IND     | Tucson      | next month       | 2 seniors          | Economy    | No       |


# This is an example of using test data sourced from the Flight_Searches worksheet in /features/support/test_data/data.xls.
# The itinerary_name value is the row_name in the worksheet.
  Scenario Outline: Search for flights with fixed dates using externally sourced data
    Given I am on the Flight Booking Home page
    When I perform a search using <itinerary_name>
    Then I should see search results on the Flight Search Results page

    Examples:
      | itinerary_name |
      | CA_CA_fixed    |
      | UK_UK_fixed    |
      | US_FR_fixed    |
      | DE_ES_fixed    |


  Scenario Outline: No results returned for search with invalid criteria
    Given I am on the Flight Booking Home page
    When I select a search type of Round Trip
    And I perform a search using:
      | From      | <origin>      |
      | To        | <destination> |
      | Flexible  | No            |
      | Depart    | <depart date> |
      | Return    | <return date> |
      | Travelers | <travelers>   |
      | Nonstop   | yes           |
    Then I should not see search results on the Flight Search Results page

    Examples:
      | origin | destination | depart date | return date     | travelers                         |
      | SEA    | EVN         | tomorrow    | 3 days from now | 4 seniors                         |
      | YWG    | PNK         | today       | 4 days from now | 2 adults, 1 child (2-4), 1 infant |
