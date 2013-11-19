Feature: Add message

Scenario: Add one page and see it on my messages page
Given I am signed in
When I add a page entitled "my first page"
Then I should see the page "hello from me" on the home page

=begin
Given there is an authenticated User
When I visit the add message page
Then I should see "Create a micropost"
When I add a message "hello from me"
When I visit my messages page
Then I should see "hello from me"


Scenario: Add two messages and see them on my messages page
Given there is an authenticated User
When I visit the add message page
When I add a message "hello from me"
When I visit the add message page
When I add a message "greetings from me"
When I visit my messages page
Then I should see "hello from me"
Then I should see "greetings from me"=end
