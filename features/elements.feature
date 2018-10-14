Feature: Interaction with groups of elements

  I want to be able to interact with element collections on a page
  In order to work with large collections of data

  Background:
    When I navigate to the home page

  Scenario: Get text from group of elements
    Then I can get the text values for the group of links

  Scenario: Filter information out from a set of elements
    Then I can see the first row
    And I can see a row using a capybara class query

  Scenario: Get groups of elements from within a section
    Then I can see individual people in the people list
    And I can see optioned individual people in the people list

  Scenario: Page with no elements
    Then the page does not have a group of elements

  Scenario: Waiting on a set of elements to appear - Positive
    Then I can wait a variable time and pass query parameters

  Scenario: Waiting on a set of elements to disappear - Positive
    When I navigate to the vanishing page
    Then I can wait a variable time for elements to disappear
