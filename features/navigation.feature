Feature: Page Navigation

  Scenario: Navigate to a page
    When I navigate to the home page
    Then I am on the home page

  Scenario: Navigate to a dynamic page
    When I navigate to the letter A page
    Then I am on a dynamic page

  Scenario: Wait to be redirected to a page
    When I navigate to the redirect page
    Then I am on the redirect page
    And I will be redirected to the home page

  Scenario: Navigate to the wrong page
    When I navigate to the home page
    Then I am not on the redirect page
