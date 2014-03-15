Feature: Wiki page

  Background:
    Given I am signed in

  Scenario: Edit page title
    When I create a page entitled "Test" with content "Test me"
    And I change the title to "Famous Photographer"
    Then I can see the title is ok
    And the save button is enabled

  Scenario: Edit page title
    When I create a page entitled "Pre-existing title" with content "Test me"
    When I create a page entitled "Test" with content "Test me"
    And I change the title to "Pre-existing title"
    Then I can see the title is not ok
    And the save button is not enabled
