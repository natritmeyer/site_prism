Feature: Malformed Items

  I want to check that I have defined my SitePrism objects correctly

  Background:
    When I navigate to a page with no title

  Scenario: Element without a selector
    Then an exception is raised when I deal with an element with no selector

  Scenario: Elements without a selector
    Then an exception is raised when I deal with elements with no selector
