Feature: Page Navigation

  I want to be able to load and navigate around the web
  In order to interact with different pages

  Scenario: Load page
    When I navigate to the home page
    Then I am on the home page

  Scenario: Load dynamic page
    When I navigate to the letter A page
    Then I am on a dynamic page

  Scenario: Load redirecting page
    When I navigate to the redirect page
    Then I am on the redirect page
    And I will be redirected to the home page

  Scenario: Load different page
    When I navigate to the home page
    Then I am not on the redirect page

  Scenario: Navigating to a different page
    When I navigate to the home page
    And I click the go button
    Then I will be redirected to the page without a title
