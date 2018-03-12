Feature: IFrame interaction

  Background:
    When I navigate to the home page

  Scenario: locate an iframe by id
    Then I can locate the iframe by id

  Scenario: locate an iframe by index
    Then I can locate the iframe by index

  Scenario: interact with elements in an iframe
    Then I can see elements in an iframe
    And I can see elements in an iframe with capybara query options
