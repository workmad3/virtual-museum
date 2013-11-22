Feature: Add page

Scenario: Add one page and see it on the home page
  Given I am signed in
  When I go to the Add Page page
  And I create a page entitled 'Test' with content 'Test me'
  Then I should see a new page entitled 'Test' with content 'Test me'




