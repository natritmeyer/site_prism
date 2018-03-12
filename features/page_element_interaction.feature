Feature: Page element interaction
  As a tester
  I want to be able to interact with individual elements on a page
  In order to get and set values on the page

  Scenario: Get the page title
    When I navigate to the home page
    Then I can get the page title

  Scenario: Page with no title
    When I navigate to a page with no title
    Then the page has no title

  Scenario: Page with no element
    When I navigate to the home page
    Then the page does not have element

  Scenario: Get individual elements
    When I navigate to the home page
    Then I can see the welcome header
    And I can see the welcome header with capybara query options
    And I can see the welcome message
    And I can see the welcome message with capybara query options
    And I can see the go button
    And I can see the link to the search page
    But I cannot see the missing squirrel
    And I cannot see the missing other thingy

  Scenario: Get individual elements with query options
    When I navigate to the home page
    Then the welcome header is not matched with invalid text

  Scenario: Wait for element
    When I navigate to the home page
    And I wait for the element that takes a while to appear
    Then the slow element appears

  Scenario: Wait specific amount of time for element to appear
    When I navigate to the home page
    And I wait for a short amount of time for an element to appear
    Then the element I am waiting for doesn't appear in time

  Scenario: Page without `expected_elements`
    When I navigate to the home page
    Then not all expected elements are present

  Scenario: Page with `expected_elements`
    When I navigate to the home page that contains expected elements
    Then all elements marked as expected are present

  Scenario: Element without a selector (pending element)
    When I navigate to a page with no title
    Then an exception is raised when I try to deal with an element with no selector
    And an exception is raised when I try to deal with elements with no selector

  Scenario: Wait for visibility of element
    When I navigate to the home page
    And I wait until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait specific amount of time for visibility of element
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait for too short an amount of time for an element to become visible
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never appears

  Scenario: Wait for invisibility of element
    When I navigate to the home page
    And I wait for an element to become invisible
    Then the previously visible element is invisible

  Scenario: Wait specific amount of time for invisibility of element
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is invisible
    Then the previously visible element is invisible

  Scenario: Wait for too short an amount of time for an element to become invisible
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never disappears

  Scenario: Don't wait for an element that doesn't exist to become invisible
    When I navigate to the home page
    Then I do not wait for an nonexistent element when checking for invisibility

  Scenario: Wait for invisibility of an element embedded into a section
    When I navigate to the home page
    And I wait for invisibility of an element embedded into a section which is removed
    Then I receive an error when a section with the element I am waiting for is removed
