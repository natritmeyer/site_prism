Feature: Page element interaction
	As a tester
	I want to be able to interact with individual elements on a page
	In order to get and set values on the page
	
	Scenario: Get the page title
		When I navigate to the home page
		Then I can get the page title
	
	Scenario: Page with no title
		When I navigate to a page with no title
		Then the page has no title
	
	Scenario: Get individual elements
		When I navigate to the home page
		Then I can see the welcome header
		And I can see the welcome message
		And I can see the go button
		And I can see the link to the search page
		But I cannot see the missing squirrel
		And I cannot see the missing other thingy
	
	Scenario: Wait for element
		When I navigate to the home page
		Then when I wait for the element that takes a while to appear
		Then I successfully wait for it to appear

  Scenario: Wait specific amount of time for element to appear
    When I navigate to the home page
    And I wait for a specifically short amount of time for an element to appear
    Then the element I am waiting for doesn't appear in time

	Scenario: Check that all elements are present
		When I navigate to the home page
		Then all expected elements are present

  Scenario: Element without a locator (pending element)
    When I navigate to a page with no title
    Then an exception is raised when I try to deal with an element with no locator
    And an exception is raised when I try to deal with elements with no locator

  Scenario: Wait for visibility of element
    When I navigate to the home page
    And I wait until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait specific amount of time for visibility of element
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is visible
    Then the previously invisible element is visible

  Scenario: Wait for too short an amount of time for an element to become visible
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never appears

  Scenario: Wait for invisibility of element
    When I navigate to the home page
    And I wait while for an element to become invisible
    Then the previously visible element is invisible

  Scenario: Wait specific amount of time for invisibility of element
    When I navigate to the home page
    And I wait for a specific amount of time until a particular element is invisible
    Then the previously visible element is invisible

  Scenario: Wait for too short an amount of time for an element to become visible
    When I navigate to the home page
    Then I get a timeout error when I wait for an element that never disappears

