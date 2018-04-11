Feature: Page Properties

  I want to obtain a variety of properties about a full page

  Background:
    When I navigate to the home page

  Scenario: Page html
    Then I can see an expected bit of the html

  Scenario: Page text
    Then I can see an expected bit of text

  Scenario: Page url
    Then I can see the expected url

  Scenario: Is page secure?
    Then I can see that the page is not secure

  Scenario: Page title - Defined
    Then I can get the page title

  Scenario: Page title - Undefined
    When I navigate to a page with no title
    Then the page has no title
