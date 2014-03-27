require 'spec_helper'
require './lib/parsing/link_interpreter'

describe ContentHtmlGenerator do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page, original_title: 'My title')
    @page_state = FactoryGirl.create(:page_state, title: @page.original_title, user: @user, page: @page)
  end

  it "should process plain text" do
    @page.change(@user, title: 'My title', content: 'abc')
    ContentHtmlGenerator.generate(@page).should ==
        "<p>abc</p>\n"
  end

  it "should process an existing page title" do
    @page.change(@user, title: 'My title', content: 'pre-amble [My title] post-amble')
    @page.title.should == 'My title'
    ContentHtmlGenerator.generate(@page).should ==
        "<p>pre-amble <a href='/pages/my-title' data-page>My title</a> post-amble</p>\n"
  end

  it "should process a non-existing page title" do
    @page.change(@user, title: 'My title', content: 'pre-amble [My non-existent title] post-amble')
    ContentHtmlGenerator.generate(@page).should ==
        "<p>pre-amble <a href='/pages/new?page_title=My non-existent title' data-new-page>My non-existent title</a> post-amble</p>\n"
  end

  it "should process an embedded image" do
    @page.change(@user, title: 'My title', content: 'pre-amble [http://a.b/img.png] post-amble')
    ContentHtmlGenerator.generate(@page).should ==
        "<p>pre-amble <div><img src='http://a.b/img.png'/></div> post-amble</p>\n"
  end

  it "should process an embedded image and width" do
    pending "can't do this yet"
    @page.change(@user, title: 'My title', content: 'pre-amble [http://a.b/img.png 100] post-amble')
    ContentHtmlGenerator.generate(@page).should ==
        "<p>pre-amble </p><div><img src='http://a.b/img.png' style='width: 100px;'/></div><p> post-amble</p>\n"
  end

  it "should process an embedded image and width in tricy circumstances" do
    pending "can't do this yet"
    @page.change(@user, title: 'My title', content: '[http://a.b/first.png 100] some text [http://a.b/second.png 100] post-amble')
    ContentHtmlGenerator.generate(@page).should ==
        "<div><img src='http://a.b/first.png' style='width: 100px;'/></div><p>some text</p><div><img src='http://a.b/second.png' style='width: 100px;'/></div><p> post-amble</p>\n"
  end

  it "should process an only on line image and width" do
    @page.change(@user, title: 'My title', content: '[http://a.b/img.png 100]')
    ContentHtmlGenerator.generate(@page).should ==
        "<div><img src='http://a.b/img.png' style='width: 100px;'/></div>\n"
  end

end
