Feature: Page Sections
	As a tester
	I want to be able to interact with element collections on a page
	In order to get and set values on the page

	Scenario: Designate a section of a page
		When I navigate to the home page
		Then I can see elements in the section
		When I navigate to another page
		Then that section is there too

	Scenario: section within a section
		When I navigate to the section experiments page
		Then I can see a section within a section
		Then I can get a parent section for a child section
		Then I can get access to a page through a child section
		Then I can get direct access to a page through a child section

	Scenario: collection of sections
		When I navigate to the section experiments page
		Then I can see a collection of sections

	Scenario: sections visible on a page
		When I navigate to the home page
		Then the section is visible

	Scenario: get section's root element
		When I navigate to the home page
		Then I can get at the people section root element

	Scenario: Check that all elements are present
		When I navigate to the section experiments page
		Then all expected elements are present in the search results

	Scenario: Check we can call JS methods against a section
		When I navigate to the section experiments page
		Then I can run javascript against the search results

	Scenario: Wait for section element
		When I navigate to the section experiments page
		Then when I wait for the section element that takes a while to appear
		Then I successfully wait for the slow section element to appear

	Scenario: Get section's parent
		When I navigate to the home page
		Then I can get access to a page through a section

