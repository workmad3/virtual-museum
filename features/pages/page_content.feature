Feature: Wiki page

  Background:
    Given I am signed in

  Scenario: Creation of a page link
    When I create a page entitled "Test" with content "Link to new [Test me] page"
    Then I can see a hyperlink to a "Test me" page

  Scenario: Creation of a url
    When I create a page entitled "Test" with content "Link to new [http://hedtek.com] page"
    Then I can see a hyperlink to a "http://hedtek.com" page

  Scenario: Creation of a url with texy
    When I create a page entitled "Test" with content "Link to new [http://hedtek.com hedtek home] page"
    Then I can see a hyperlink to a "hedtek home" page

  Scenario: Creation of a an image
    When I create a page entitled "Test" with content "Link to new [http://hedtek.com/im.png] page"
    Then I can see a rendition of an image

  Scenario: Creation of a video content
    When I create a page entitled "Test" with content "Link to new [http://youtube.com/vids page"
    Then I can see a You Tube video

  Scenario: Creation of a video content
    When I create a page entitled "Test" with content "Link to new [http://youtube.com/vids page"
    Then I can see a Vimeo video