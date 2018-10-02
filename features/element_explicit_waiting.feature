Feature: Waiting for an Element

  I want to be able to explicitly wait for an element
  In order to interact with the element once it is ready

  Scenario: Wait for Element - Positive - Overridden Timeout
    When I navigate to the home page
    And I wait for the element that takes a while to appear
    Then the slow element appears
    And I am not made to wait for the full overridden duration

  Scenario: Wait for Element - Negative - Overridden Timeout
    When I navigate to the home page
    Then an exception is raised when I wait for an element that won't appear

  Scenario: Wait for Element Visibility - Positive - Overridden Timeout
    When I navigate to the home page
    And I wait for a specific amount of time until an element is visible
    Then the previously invisible element is visible
    And I am not made to wait for the full overridden duration

  Scenario: Wait for Element Visibility - Negative - Overridden Timeout
    When I navigate to the home page
    Then I get a timeout error when waiting for an element within the limit

  Scenario: Wait for Element Visibility - Positive - Default Timeout
    When I navigate to the home page
    And I wait until a particular element is visible
    Then the previously invisible element is visible
    And I am not made to wait for the full default duration

  Scenario: Wait for Element Visibility - Negative - Default Timeout
    When I navigate to the home page
    Then I get a timeout error when waiting for an element with default limit

  Scenario: Wait for Element Invisibility - Positive - Overridden Timeout
    When I navigate to the home page
    And I wait a specific amount of time for a particular element to vanish
    Then the previously visible element is invisible

  Scenario: Wait for Element Invisibility - Negative - Overridden Timeout
    When I navigate to the home page
    Then I get an error when I wait for an element to vanish within the limit

  Scenario: Wait for Element Invisibility - Positive - Default Timeout
    When I navigate to the home page
    And I wait for an element to become invisible
    Then the previously visible element is invisible

  Scenario: Wait for Element Invisibility - Negative - Default Timeout
    When I navigate to the home page
    Then an exception is raised when I wait for an element that won't vanish

  Scenario: Wait for Element Invisibility - Non-Existent Element - Overridden Timeout
    When I navigate to the home page
    Then I am not made to wait to check a nonexistent element for invisibility

  Scenario: Wait for Element Invisibility - Non-Existent Section - Overridden Timeout
    When I navigate to the home page
    And I remove the parent section of the element
    Then an error is thrown when waiting for an element in a vanishing section

  Scenario: Wait time can be overridden at run-time in a block
    When I navigate to the home page
    Then I can override the wait time using a Capybara.using_wait_time block
