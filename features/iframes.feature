Feature: IFrame interaction

  Scenario: locate an iframe
    When I navigate to the home page
    Then I can see an iframe

  Scenario: interact with elements in an iframe
    When I navigate to the home page
    Then I can see elements in an iframe
    And I can see an expected bit of text

