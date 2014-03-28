require 'spec_helper'

describe Page do
  def user() @user end
  def page() @page end
  def page_state() @page_state end
  def user2() @user2 end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page, creator: @user, content: "check me")
    @page_state = @page.history.first
    @user2 = FactoryGirl.create(:user)
    subject {@page}
  end

  it { page_state.should validate_presence_of(:title) }
  it { page_state.should validate_presence_of(:content) }

  it "should have only the original page state after creation" do
    page.history.should == [page_state]
  end

  it "should be able to change title" do
    original_content = page_state.content
    page.update_attributes(creator: user, title: 'check me', content: original_content)
    page.title.should == 'check me'
    page.content.should == original_content
  end

  it "should be able to change content" do
    original_title = page_state.title
    page.change(user, title: original_title, content: 'check me')
    PageState.count.should == 2
    page.title.should == original_title
    page.content.should == 'check me'
  end

  it "should have one past page after one change" do
    original_title = page_state.title
    page.change(user, title: original_title, content: ' xxx ')
    page.history.count.should == 2
  end

  it "should have two past pages after two changes" do
    original_title = page_state.title
    page.change(user, title: original_title, content: ' xxx ')
    page.change(user, title: original_title, content: ' zzzz ')
    Page.first.history.count.should == 3
  end

  it "page state should be correct after a change" do
    PageState.count.should == 1
    original_title = page_state.title
    original_content = page_state.content

    page.change(user2, title: 'New title', content: 'New content')
    PageState.count.should == 2

    prev_page_state = PageState.first
    prev_page_state.title.should == original_title
    prev_page_state.content.should == original_content
    prev_page_state.user.should == user

    current_page_state = PageState.last
    current_page_state.title.should == 'New title'
    current_page_state.content.should == 'New content'
    current_page_state.user.should == user2
  end

  it "page title and content should reflect with sucessive changes" do
    original_content = page.content
    original_title = page.title

    page.update_attributes(creator: user, title: 'first title change', content: 'first content change')
    page.title.should == 'first title change'
    page.content.should == 'first content change'

    page.update_attributes(creator: user, title: 'second title change', content: 'second content change')
    page.title.should == 'second title change'
    page.content.should == 'second content change'
  end

  it "a page's history should only contain the page's past" do
    original_content = page.content
    original_title = page_state.title
    page.update_attributes(creator: user, title: original_title, content: 'first content change')
    page.update_attributes(creator: user, title: original_title, content: 'second content change')

    @page2 = FactoryGirl.create(:page, creator: @user, content: "check me")
    @page_state2 = @page2.history.first

    history = Page.first.history
    history.count.should == 3
    history[0].content.should == original_content
    history[1].content.should == 'first content change'
    history[2].content.should == 'second content change'
  end

end





