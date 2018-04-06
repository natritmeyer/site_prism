Feature: Malformed Items

  I want to check that I have defined my SitePrism objects correctly

  Scenario: Element without a selector
    When I navigate to a page with no title
    Then an exception is raised when I try to deal with an element with no selector

  Scenario: Elements without a selector
    When I navigate to a page with no title
    Then an exception is raised when I try to deal with elements with no selector
