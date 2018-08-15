Feature: Page Sections

  I want to be able to interact with a section of a page
  In order to get and set values on the page

  Scenario: Designate a section of a page
    When I navigate to the home page
    Then I can see elements in the section
    When I navigate to the people page
    Then I can see a list of people

  Scenario: access elements in the section by passing a block
    When I navigate to the home page
    Then I can access elements within the section using a block
    But I cannot access elements that are not in the section using a block

  Scenario: section in a section
    When I navigate to the section experiments page
    Then I can see a section in a section

  Scenario: section within a section using blocks
    When I navigate to the section experiments page
    Then I can see a section within a section using nested blocks

  Scenario: section within a section using class & blocks
    When I navigate to the home page
    Then I can see elements from the parent section
    And I can see elements from the block

  Scenario: section scoping
    When I navigate to the home page
    Then access to elements is constrained to those within the section

  Scenario: anonymous section
    When I navigate to the section experiments page
    Then I can see an anonymous section

  Scenario: section visible on a page
    When I navigate to the home page
    Then the section is visible

  Scenario: get root element belonging to section
    When I navigate to the home page
    Then I can access the sections root element

  Scenario: Check that all elements are present
    When I navigate to the section experiments page
    Then all expected elements are present in the search results

  Scenario: Check we can call JS methods against a section
    When I navigate to the section experiments page
    And I execute some javascript to set a value
    Then I can evaluate some javascript to get the value

  Scenario: Wait for section
    When I navigate to the section experiments page
    And I wait for the section element that takes a while to appear
    Then the slow section appears

  Scenario: Wait for section to disappear
    When I navigate to the section experiments page
    And I wait for the section element that takes a while to disappear
    Then the removing section disappears

  Scenario: Wait for section - Exceptions - Positive
    When I navigate to the section experiments page
    And I wait for the section element that takes a while to appear
    Then the slow section appears

  Scenario: Wait for section - Exceptions - Negative
    When I navigate to the section experiments page
    Then an exception is raised when I wait for a section that won't appear

  Scenario: Wait for section to disappear - Exceptions - Positive
    When I navigate to the section experiments page
    And I wait for the section element that takes a while to disappear
    Then the removing section disappears

  Scenario: Wait for section to disappear - Exceptions - Negative
    When I navigate to the section experiments page
    Then an exception is raised when I wait for a section that won't disappear

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

  Scenario: Page with a deeply nested section
    When I navigate to the section experiments page
    Then the page contains a deeply nested span

  Scenario: get text from page section
    When I navigate to the home page
    Then I can see a section's full text

  Scenario: Get native property from section
    When I navigate to the home page
    Then I can obtain the native property of a section
