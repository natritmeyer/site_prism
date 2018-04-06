Feature: Element Methods

  I want to be able to perform some basic commands on elements
  In order to get values on the page

  Scenario: Element Text - Positive Test
    When I navigate to the home page
    Then I can see the welcome header
    And I can see the welcome header with capybara query options
    And I can see the welcome message
    And I can see the welcome message with capybara query options

  Scenario: Element Text - Negative Test
    When I navigate to the home page
    Then the page does not have element
    And the welcome header is not matched with invalid text

  Scenario: Element Properties - HREF
    When I navigate to the home page
    Then I can see the link to the search page

  Scenario: Expected Elements Present - Positive
    When I navigate to the home page that contains expected elements
    Then all elements marked as expected are present

  Scenario: Expected Elements Present - Negative
    When I navigate to the home page
    Then not all expected elements are present

  Scenario: Get native property from element
    When I navigate to the home page
    Then I can obtain the native property of an element
