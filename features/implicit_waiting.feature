Feature: Waiting for Elements Implicitly

  I want to be able to implicitly wait for an element
  In order to interact with the element once it is ready

  Background:
    When I navigate to the home page

  Scenario: Element is Automatically Waited For
    Then the slow element is waited for

  Scenario: Elements are Automatically Waited For
    Then the slow elements are waited for

  Scenario: Section is Automatically Waited For
    Then the slow section is waited for

  Scenario: Sections are Automatically Waited For
    Then the slow sections are waited for

  Scenario: Boolean test for Element is Automatically Waited For
    Then the boolean test for a slow element is waited for

  Scenario: Boolean test for Elements is Automatically Waited For
    Then the boolean test for slow elements are waited for

  Scenario: Boolean test for Section is Automatically Waited For
    Then the boolean test for a slow section is waited for

  Scenario: Boolean test for Sections is Automatically Waited For
    Then the boolean test for slow sections are waited for
