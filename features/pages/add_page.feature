Feature: Add page

Scenario: Add a page and then see it
  Given I am signed in
  When I go to the Add Page page
  And I create a page entitled "Test" with content "Test me"
  Then I should see a new page entitled "Test" with content "Test me"




