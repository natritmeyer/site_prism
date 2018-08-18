@implicit_waits
Feature: Waiting for Elements Implicitly

  I want to be able to implicitly wait for an element
  In order to interact with the element once it is ready

  Scenario: Elements Are Automatically Waited For
    When I navigate to the home page
    Then the slow element is waited for
    And implicit waits should be enabled

  Scenario: Element Collections Are Automatically Waited For
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

  Scenario: Boolean test for Element is Automatically Waited For
    When I navigate to the home page
    Then the boolean test for a slow element is waited for

  Scenario: Boolean test for Elements is Automatically Waited For
    When I navigate to the home page
    Then the boolean test for slow elements are waited for

  Scenario: Boolean test for Section is Automatically Waited For
    When I navigate to the home page
    Then the boolean test for a slow section is waited for

  Scenario: Boolean test for Sections is Automatically Waited For
    When I navigate to the home page
    Then the boolean test for slow sections are waited for

  Scenario: Wait time can be overridden at run-time
    When I navigate to the home page
    Then a slow element is waited for if a user sets Capybara.using_wait_time
    And implicit waits should be enabled
