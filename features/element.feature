Feature: Element Methods

  I want to be able to perform some basic commands on an element
  In order to get specific values from them

  Scenario: Element Text - Positive Test
    When I navigate to the home page
    Then I can see the welcome header
    And I can see the welcome header using a capybara text query
    And I can see the welcome message
    And I can see the welcome message using a capybara text query

  Scenario: Element Text - Negative Test
    When I navigate to the home page
    Then the page does not have element
    And the welcome header is not matched with invalid text

  @medium-speed
  Scenario: Element Properties
    When I navigate to the home page
    Then I can see the the HREF of the link
    And I can see the CLASS of the link

  Scenario: Expected Elements Present - Positive
    When I navigate to the home page that contains expected elements
    Then all elements marked as expected are present

  @medium-speed
  Scenario: Expected Elements Present - Negative
    When I navigate to a page with no title
    Then not all expected elements are present

  Scenario: Elements Present - Positive
    When I navigate to the letter A page
    Then all mapped elements are present

  @slow-speed
  Scenario: Elements Present - Negative
    When I navigate to the home page
    Then not all mapped elements are present

  Scenario: Get native property from element
    When I navigate to the home page
    Then I can obtain the native property of an element
