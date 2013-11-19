Feature: Add page

Scenario: Add one page and see it on the home page
Given I am signed in
When I add a page entitled "my first page"
Then I should see the page "my first page" on the home page




