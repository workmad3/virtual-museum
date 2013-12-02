Feature: Wiki page

  Background:
    Given I am signed in

  Scenario: Add a page and then see it
    When I create a page entitled "Test" with content "Test me"
    Then I can see a page entitled "Test" with content "Test me"

  Scenario: Edit page body

    When I create a page entitled "Test" with content "Test me"
    And I change the content to "Mario Testino"
    Then I can see a page entitled "Test" with content "Mario Testino"

  Scenario: Edit page title
    When I create a page entitled "Test" with content "Test me"
    And I change the title to "Famous Photographer"
    Then I can see a page entitled "Famous Photographer" with content "Test me"








