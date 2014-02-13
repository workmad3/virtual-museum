require 'spec_helper'

RSpec.configure do |config|
  config.include(UserAndPageHelpers)
end

describe Page do
  before(:each) do
    user
    page
    user2
    page2
    subject { page }
  end

  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }

  it "should be able to change content" do
    original_title = page.title
    original_creator = page.user

    page.change(user, content: 'check me')
    page.content.should == 'check me'
    page.title.should == original_title
    page.user == original_creator
  end

  # TODO test Page#change


  it "should be able to change title" do
    original_content = page.content
    original_creator = page.user

    page.change(user, title: 'check me')
    page.title.should == 'check me'
    page.content.should == original_content
    page.user == original_creator
  end

  it "should have no previous pages after creation" do
    page.history.should == []
  end

  it "should create a past page after a change" do
    PreviousPage.count.should == 0
    original_content = page.content

    page.change(user2, content: ' xxx ')
    PreviousPage.count.should == 1
    prev_page = PreviousPage.first

    prev_page.title.should == page.title
    prev_page.content.should == original_content

    prev_page.page.should == page
    prev_page.user.should == user
  end

  it "should have one past page after one change" do
    page.change(user, content: ' xxx ')
    page.history.count.should == 1
  end

  it "should have two past pages after two changes" do
    page.change(user, content: ' xxx ')
    page.change(user, content: ' zzzz ')
    Page.first.history.count.should == 2
  end

  it "history should only contain correct pages" do
    original_page_content = page.content
    original_page2_content = page2.content

    page.change(user, content: 'first content change')
    page.change(user, content: 'second content change, not tested')
    page2.change(user, content: 'first content change, also not tested')

    history = Page.first.history
    history.count.should == 2
    history[0].content.should == 'first content change'
    history[1].content.should == original_page_content

    history2 = Page.last.history
    history2.count.should == 1
    history2[0].content.should == original_page2_content
  end
end





