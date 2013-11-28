require 'spec_helper'

def user
  @user || @user = FactoryGirl.create(:user)
end
def page
  @page || @page = FactoryGirl.create(:page, user: user)
end
def user2
  @user2 || @user2 = FactoryGirl.create(:user)
end
def page2
  @page2 || @page2 = FactoryGirl.create(:page, user: user2)
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

    page.change_content(user: user, content: 'check me')
    page.content.should == 'check me'
    page.title.should == original_title
    page.user == original_creator
  end

  # TODO test Page#change


  it "should be able to change title" do
    original_content = page.content
    original_creator = page.user

    page.change_title(user: user, title: 'check me')
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

    page.change_content(user: user2, content: ' xxx ')
    PreviousPage.count.should == 1
    prev_page = PreviousPage.first

    prev_page.title.should == page.title
    prev_page.content.should == original_content

    prev_page.page.should == page
    prev_page.user.should == user2
  end

  it "should have one past page after one change" do
    page.change_content(user: user, content: ' xxx ')
    page.history.count.should == 1
  end

  it "should have two past pages after two changes" do
    page.change_content(user: user, content: ' xxx ')
    page.change_content(user: user, content: ' zzzz ')
    Page.first.history.count.should == 2
  end

  it "history should only return correct pages" do
    original_page_content = page.content
    original_page2_content = page2.content

    page.change_content(user: user, content: 'first content change')
    page.change_content(user: user, content: 'second content change, not tested')
    page2.change_content(user: user, content: 'first content change, also not tested')

    history = Page.find_by_user_id(user.id).history
    history.count.should == 2
    history[0].content.should == 'first content change'
    history[1].content.should == original_page_content

    history2 = Page.find_by_user_id(user2.id).history
    history2.count.should == 1
    history2[0].content.should == original_page2_content
  end
end





