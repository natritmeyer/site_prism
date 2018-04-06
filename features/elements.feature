Feature: Interaction with groups of elements

  I want to be able to interact with element collections on a page
  In order to work with large collections of data

  Scenario: Get groups of elements
    When I navigate to the home page
    Then I can see the group of links
    And I can get the group of links

  Scenario: Get groups of elements from within a section
    When I navigate to the home page
    Then I can see individual people in the people list

  Scenario: Page with no elements
    When I navigate to the home page
    Then the page does not have elements

  Scenario: Waiting on a set of elements
    When I navigate to the home page
    Then I can wait a variable time for elements to appear
    Then I can wait a variable time and pass specific parameters
