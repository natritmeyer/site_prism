Feature: Page Properties

  Background:
    When I navigate to the home page

  Scenario: Get page html
    Then I can see an expected bit of the html

  Scenario: Get page text
    Then I can see an expected bit of text

  Scenario: Get page url
    Then I can see the expected url

  Scenario: Is page secure?
    Then I can see that the page is not secure
