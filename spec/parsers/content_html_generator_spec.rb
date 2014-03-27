require 'spec_helper'
require './lib/parsing/link_interpreter'

describe ContentHtmlGenerator do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page)
    @page_state = FactoryGirl.create(:page_state, title: @page.original_title, user: @user, page: @page)

  end

  it "should process plain text" do
    @page.change(@user, title: 'My title', content: 'abc')
    ContentHtmlGenerator.generate(@page).should == "<p>abc</p>\n"
  end

  it "should process an existing page title" do
    @page.change(@user, title: 'My title', content: 'pre-amble [My title] post-amble')
    @page.title.should == 'My title'
    ContentHtmlGenerator.generate(@page).should == "<p>pre-amble <a href='/pages/my-title' data-page>My title</a> post-amble</p>\n"
  end

  it "should process a non-existing page title" do
    @page.change(@user, title: 'My title', content: 'pre-amble [My non-existent title] post-amble')
    ContentHtmlGenerator.generate(@page).should == "<p>pre-amble <a href='/pages/new?page_title=My non-existent title' data-new-page>My non-existent title</a> post-amble</p>\n"
  end

end
