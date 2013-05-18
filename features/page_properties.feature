Feature: Page properties
  As a tester
  I want to be able to get properties of the page
  In order to know more about the page

  Background:
    Given I navigate to the home page

  Scenario: Get page html
    Then I can see an expected bit of the html

  Scenario: Get page text
    Then I can see an expected bit of text

  Scenario: Get page url
    Then I can see the expected url

  Scenario: Is page secure?
    Then I can see that the page is not secure

