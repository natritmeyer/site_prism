Feature: Page Sections
  As a tester
  I want to be able to interact with element collections on a page
  In order to get and set values on the page

  Scenario: Designate a section of a page
    When I navigate to the home page
    Then I can see elements in the section
    When I navigate to the people page
    Then I can see a list of people

  Scenario: access elements in the section by passing a block
    When I navigate to the home page
    Then I can access elements within the section using a block
    But I cannot access elements not in the section using a block

  Scenario: section in a section
    When I navigate to the section experiments page
    Then I can see a section in a section

  Scenario: section within a section using blocks
    When I navigate to the section experiments page
    Then I can see a section within a section using nested blocks

  Scenario: section scoping
    When I navigate to the home page
    Then access to elements is constrained to those within the section

  Scenario: collection of sections
    When I navigate to the section experiments page
    Then I can see a collection of sections

  Scenario: anonymous section
    When I navigate to the section experiments page
    Then I can see an anonymous section

  Scenario: anonymous sections collection
    When I navigate to the section experiments page
    Then I can see a collection of anonymous sections

  Scenario: sections visible on a page
    When I navigate to the home page
    Then the section is visible

  Scenario: get root element belonging to section
    When I navigate to the home page
    Then I can get at the people section root element

  Scenario: Check that all elements are present
    When I navigate to the section experiments page
    Then all expected elements are present in the search results

  Scenario: Check we can call JS methods against a section
    When I navigate to the section experiments page
    Then I can run javascript against the search results

  Scenario: Wait for section
    When I navigate to the section experiments page
    And I wait for the section element that takes a while to appear
    Then the slow section appears

  Scenario: Get parent belonging to section
    When I navigate to the home page
    Then I can get access to a page through a section

  Scenario: get parent section for a child section
    When I navigate to the section experiments page
    Then I can get a parent section for a child section

  Scenario: get page from child section
    When I navigate to the section experiments page
    Then I can get access to a page through a child section

  Scenario: directly access page through child section
    When I navigate to the section experiments page
    Then I can get direct access to a page through a child section

  Scenario: Page with no section
    When I navigate to the home page
    Then the page does not have a section

  Scenario: Page with section that does not contain element
    When I navigate to the home page
    Then the page contains a section with no element

  Scenario: Page with deeply nested sections
    When I navigate to the section experiments page
    Then the page contains a deeply nested span

  Scenario: get text from page section
    When I navigate to the home page
    Then I can see a section's full text
