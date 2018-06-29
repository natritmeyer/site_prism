@implicit_waits
Feature: Waiting for Elements Implicitly

  I want to be able to implicitly wait for an element
  In order to interact with the element once it is ready

  Scenario: Elements Are Automatically Waited For
    When I navigate to the home page
    Then the slow element is waited for
    And implicit waits should be enabled

  Scenario: Elements Collections Are Automatically Waited For
    When I navigate to the home page
    Then the slow elements are waited for
    And implicit waits should be enabled

  Scenario: Sections Are Automatically Waited For
    When I navigate to the home page
    Then the slow section is waited for
    And implicit waits should be enabled

  Scenario: Sections Collections Are Automatically Waited For
    When I navigate to the home page
    Then the slow sections are waited for
    And implicit waits should be enabled

  Scenario: Wait time can be overridden at run-time
    When I navigate to the home page
    Then the slow element is waited for only as long as a user set Capybara.using_wait_time
    And implicit waits should be enabled
