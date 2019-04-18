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

  Scenario: Check we can call JS methods against a page
    When I navigate to the nested section page
    And I execute some javascript on the page to set a value
    Then I can evaluate some javascript on the page to get the value

  Scenario: Expected Elements Present - Positive
    Then all elements marked as expected are present

  @slow-test
  Scenario: Expected Elements Present - Negative
    When I navigate to a page with no title
    Then not all expected elements are present

  Scenario: All Elements Present - Positive
    When I navigate to the nested section page
    Then all elements are present

  Scenario: All Elements Present - Negative
    When I navigate to the slow page
    Then not all elements are present

  Scenario: All Elements Present (With Recursion) - Positive
    When I navigate to the letter A page
    Then all elements and first-generation descendants are present

  Scenario: All Elements Present (With Recursion) - Negative
    When I navigate to the nested section page
    Then all elements and first-generation descendants are not present

  Scenario: Elements Present - Positive
    When I navigate to the letter A page
    Then all mapped elements are present

  @slow-test
  Scenario: Elements Present - Negative
    Then not all mapped elements are present
