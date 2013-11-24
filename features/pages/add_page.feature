Feature: Wiki page

  Scenario: Add a page and then see it
    Given I am signed in
    When I go to the Add Page page
    And I create a page entitled "Test" with content "Test me"
    Then I can see a page entitled "Test" with content "Test me"

  Scenario: Edit a page
    Given I am signed in
    When I go to the Add Page page
    And I create a page entitled "Test" with content "Test me"
    Then I can see a page entitled "Test" with content "Test me"
    When I change the content to "Mario Testino"
    Then I can see a page entitled "Test" with content "Mario Testino"
    When I change the title to "Famous Photographer"
    Then I can see a page entitled "Famous Photographer" with content "Mario Testino"
    And The page slug should be "test"








