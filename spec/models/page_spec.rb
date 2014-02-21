require 'spec_helper'




describe Page do
  def user() @user end
  def page() @page end
  def page_state() @page_state end
  def user2() @user2 end
  def page2() @page2 end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page)
    @page_state = FactoryGirl.create(:page_state, title: @page.original_title, user: @user, page: @page)
    @user2 = FactoryGirl.create(:user)
    #@page2 = FactoryGirl.create(:page)
    #@page_state2 = FactoryGirl.create(:page_state, title: @page2.original_title, user: @user2, page: @page2)
    subject {@page}
  end

  it { page_state.should validate_presence_of(:user_id) }
  it { page_state.should validate_presence_of(:page_id) }


  it "should be able to change content" do
    original_title = page_state.title

    page.change(user, content: 'check me', title: original_title)
    PageState.count.should == 2
    page.content.should == 'check me'
    page.title.should == original_title
  end

  it "should be able to change title" do
    original_content = page_state.content

    page.change(user, title: 'check me', content: original_content)
    page.title.should == 'check me'
    page.content.should == original_content
  end

  it "should have only the original page state after creation" do
    page.history.should == [page_state]
  end

  it "should have current and past page state after a change" do
    PageState.count.should == 1
    original_title = page_state.title
    original_content = page.content

    page.change(user2, content: 'xxx', title: 'yyy')
    PageState.count.should == 2

    prev_page_state = PageState.last
    prev_page_state.title.should == original_title
    prev_page_state.content.should == original_content
    prev_page_state.user.should == user

    current_page_state = PageState.first
    current_page_state.title.should == 'yyy'
    current_page_state.content.should == 'xxx'
    current_page_state.user.should == user2

  end

  it "should have one past page after one change" do
    page.change(user, content: ' xxx ')
    page.history.count.should == 2
  end

  it "should have two past pages after two changes" do
    page.change(user, content: ' xxx ')
    page.change(user, content: ' zzzz ')
    Page.first.history.count.should == 3
  end

  it "history should only contain correct pages" do
    original_page_content = page.content

    page.change(user, content: 'first content change')
    page.change(user, content: 'second content change')

    @page2 = FactoryGirl.create(:page)
    @page_state2 = FactoryGirl.create(:page_state, title: @page2.original_title, user: @user, page: @page2)

    history = Page.first.history
    history.count.should == 3
    history[-1].content.should == original_page_content
    history[ 2].content.should == original_page_content

    history[1].content.should == 'first content change'
    history[0].content.should == 'second content change'

  end
end





