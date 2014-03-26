require 'spec_helper'

describe Page do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page)
    @page_state = FactoryGirl.create(:page_state, title: @page.original_title, user: @user, page: @page)
    @user2 = FactoryGirl.create(:user)
    @page2 = FactoryGirl.create(:page)
    @page_state2 = FactoryGirl.create(:page_state, title: @page2.original_title, user: @user2, page: @page2)
  end

  it "creator should be set when page first created" do
    @page.creator.should == @user
    @page2.creator.should == @user2
  end

  it "editor should be nil when page first created"  do
    @page.editor.should == nil
  end

  it "editor should be set when page content is changed"  do
    @page.change(@user2, title: @page.title, content: 'changed content')
    @page.editor.should == @user2
  end

  it "editor should be set when page title is changed" do
    @page.change(@user2, title: 'changed title', content: @page.content)
    @page.editor.should == @user2
  end

  it "editor should be set when page title and content is changed" do
    @page.change(@user2, content: 'changed title', title: 'changed title')
    @page.editor.should == @user2
  end

  it "creator should not vary when successively changing content and/or title" do
    @page.creator.should == @user
    @page.change(@user2, title: @page.title, content: 'changed content')
    @page.creator.should == @user
    @page.change(@user2, title: @page.title, content: 'changed content')
    @page.creator.should == @user
    @page.change(@user2, title: 'changed title', content: 'changed content again')
    @page.creator.should == @user
  end

  it "editor should vary appropriately when successively changing content and/or title" do
    @page.editor.should == nil
    @page.change(@user2, title: @page.title, content: 'changed content')
    @page.editor.should == @user2
    @page.change(@user, title: @page.title, content: 'changed content')
    @page.editor.should == @user
    @page.change(@user2, title: 'changed title', content: 'changed content again')
    @page.editor.should == @user2
  end

end
