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

  it "creator should be set when page first created" do
    page.user.should == user
    page.creator.should == user
    page2.user.should == user2
    page2.creator.should == user2
  end

  it "editor should be nil when page first created"  do
    page.editor.should == nil
  end

  it "editor should be set when page content is changed"  do
    page.change_content(user: user2, content: 'changed content')
    page.user.should == user2
    page.editor.should == user2
  end

  it "editor should be set when page title is changed" do
    page.change_title(user: user2, content: 'changed title')
    page.user.should == user2
    page.editor.should == user2
  end

  it "editor should be set when page title or content is changed" do
    page.change(user2, content: 'changed title')
    page.user.should == user2
    page.editor.should == user2
  end

  it "creator should not vary when successively changing content" do
    page.creator.should == user
    page.change_content(user: user2, content: 'changed content')
    page.creator.should == user
    page.change_content(user: user2, content: 'changed content')
    page.creator.should == user
  end

  it "creator should not vary when successively changing title"  do
    page.creator.should == user
    page.change_title(user: user2, content: 'changed title')
    page.creator.should == user
    page.change_title(user: user2, content: 'changed title')
    page.creator.should == user
  end

  it "creator should not vary when successively changing title"  do
    page.creator.should == user
    page.change(user2, content: 'changed content')
    page.creator.should == user
    page.change(user2, title: 'changed title')
    page.creator.should == user
  end
end
