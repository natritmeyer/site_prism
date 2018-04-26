Feature: Waiting for Elements

  I want to be able to implicitly wait for an element
  In order to interact with the element once it is ready

  Scenario: Wait for Element - Positive
    When I navigate to the home page
    And I wait for the element that takes a while to appear
    Then the slow element appears

  Scenario: Wait for Element - Negative
    When I navigate to the home page
    And I wait for a short amount of time for an element to appear
    Then the element I am waiting for doesn't appear in time

  Scenario: Wait for Element - Exceptions - Positive
    Given exceptions are configured to raise on wait_fors
    When I navigate to the home page
    And I wait for the element that takes a while to appear
    Then the slow element appears

  Scenario: Wait for Element - Exceptions - Negative
    Given exceptions are configured to raise on wait_fors
    When I navigate to the home page
    Then an exception is raised when I wait for an element that won't appear

  Scenario: Wait for Visibility of element - Default Timeout
    When I navigate to the home page
    And I wait until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait for Visibility of element - Overridden Timeout
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait for Visibility of element - Negative Test
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never appears

  Scenario: Wait for Invisibility of element - Default Timeout
    When I navigate to the home page
    And I wait for an element to become invisible
    Then the previously visible element is invisible

  Scenario: Wait for Invisibility of element - Overriden Timeout
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is invisible
    Then the previously visible element is invisible

  Scenario: Wait for Invisibility of element - Negative Test
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never disappears

  Scenario: Wait for Invisibility of element - Non-Existent Element
    When I navigate to the home page
    Then I do not wait for an nonexistent element when checking for invisibility

  Scenario: Wait for Invisibility of element - Non-Existent Section
    When I navigate to the home page
    And I remove the parent section of the element
    Then I receive an error when a section with the element I am waiting for is removed
