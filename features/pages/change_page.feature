Feature: Wiki page

  Background:
    Given I am signed in

  Scenario: Edit page body

    When I create a page entitled "Test" with content "Test me"
    And I change the content to "Mario Testino"
    Then I can see a page entitled "Test" with content "Mario Testino"

  Scenario: Edit page title
    When I create a page entitled "Test" with content "Test me"
    And I change the title to "Famous Photographer"
    Then I can see a page entitled "Famous Photographer" with content "Test me"

  Scenario: Edits to a page should be recorded in page history

    When I create a page entitled "Test" with content "Test me"
    And I change the content to "Mario Testino"
    And I change the title to "Famous Photographer"

    Then I can see one item of page history containing "Test me" as third most recent
    Then I can see one item of page history containing "Mario Testino" as second most recent
    Then I can see one item of page history containing "Famous Photographer" as most recent








