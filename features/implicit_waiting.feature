@implicit_waits
Feature: Waiting for Elements

  I want to be able to implicitly wait for an element
  In order to interact with the element once it is ready

  Scenario: Elements Are Waited For
    When I navigate to the home page
    Then the slow element is waited for
    And implicit waits are enabled
