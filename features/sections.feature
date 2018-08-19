Feature: Interaction with groups of elements

  I want to be able to interact with section collections on a page
  In order to work with large collections of data

  Scenario: collection of sections
    When I navigate to the section experiments page
    Then I can see a collection of sections

  @migrated
  Scenario: waiting on a collection of sections to disappear
    When I navigate to the home page
    And I wait for the collection of sections that takes a while to disappear
    Then the removing collection of sections disappears

  Scenario: anonymous sections collection
    When I navigate to the section experiments page
    Then I can see a collection of anonymous sections