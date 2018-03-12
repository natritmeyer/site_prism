Feature: Interaction with groups of elements

  I want to be able to interact with element collections on a page

  Background:
    When I navigate to the home page

  Scenario: Get text from group of elements
    Then I can get the text values for the group of links

  Scenario: Get groups of elements from within a section
    Then I can see individual people in the people list

  Scenario: Page with no elements
    Then the page does not have a group of elements

  Scenario: Waiting on a set of elements
    When I wait a variable time for elements to appear
    Then I can wait a variable time and pass specific parameters
