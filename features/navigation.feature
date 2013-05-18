Feature: Page navigation
  As a tester
  I want to be able to point my test at a page
  In order to interact with it

  Scenario: Navigate to a page
    When I navigate to the home page
    Then I am on the home page

  Scenario: Navigate to a dynamic page
    When I navigate to the letter A page
    Then I am on a dynamic page

