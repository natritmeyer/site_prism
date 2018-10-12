Feature: Waiting for a Section

  I want to be able to explicitly wait for a section
  In order to interact with the element once it is ready

  Background:
    When I navigate to the home page

  Scenario: Wait for Section - Positive - Overridden Timeout
    When I wait for the section that takes a while to appear
    Then the slow section appears

  Scenario: Wait for Section - Negative - Overridden Timeout
    Then an exception is raised when I wait for a section that won't appear

  Scenario: Wait for Section Invisibility - Positive - Default Timeout
    When I wait for the section that takes a while to vanish
    Then the section is no longer visible

  Scenario: Wait for Section Invisibility - Positive - Overridden Timeout
    When I wait an overridden time for the section to vanish
    Then the section is no longer visible

  @slow-speed
  Scenario: Wait for Section Invisibility - Negative - Default Timeout
    Then an error is raised when waiting for the section to vanish

  Scenario: Wait for Section Invisibility - Negative - Overridden Timeout
    Then an error is raised when waiting a new time for the section to vanish
