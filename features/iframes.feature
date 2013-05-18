Feature: IFrame interaction

  Scenario: locate an iframe by id
    When I navigate to the home page
    Then I can locate the iframe by id

  Scenario: locate an iframe by index
    When I navigate to the home page
    Then I can locate the iframe by index

  Scenario: interact with elements in an iframe
    When I navigate to the home page
    Then I can see elements in an iframe
    And I can see an expected bit of text

