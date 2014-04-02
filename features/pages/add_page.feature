Feature: Wiki page

  Background:
    Given I am signed in

  Scenario: Add a page and then see it
    When I create a page entitled "Test" with content "Test me"
    Then I can see a page entitled "Test" with content "Test me"

  Scenario: Add a tagged page and then see it
    When I create a tagged page entitled "Test" with content "Test me" and tags "a, bb"
    Then I can see a tagged page entitled "Test" with content "Test me" and tags "a, bb"







