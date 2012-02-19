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

	@wip
	Scenario: Check that all elements are present
		When I navigate to the home page
		Then all expected elements are present
