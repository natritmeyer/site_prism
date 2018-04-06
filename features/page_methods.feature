Feature: Page interaction

  I want to be able to interact with full pages

  Scenario: Page Title - Defined
    When I navigate to the home page
    Then I can get the page title

  Scenario: Page Title - Undefined
    When I navigate to a page with no title
    Then the page has no title
