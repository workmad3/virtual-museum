require 'spec_helper'

describe Page do

  def user
    @user || @user = FactoryGirl.create(:user)
  end
  def page
    @page || @page = FactoryGirl.create(:page, user: user)
  end

  before(:each) do
    DatabaseCleaner.clean
    user
    page
    subject { page }
  end

  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }

  it "should be able to change content" do
    page.change_content(user: user, content: ' xxx ')
    page.content.should == ' xxx '
  end

  it "should be able to change title" do
    page.change_title(user: user, title: ' xxx ')
    page.title.should == ' xxx '
  end

  it "should have no previous pages after creation" do
    page.history.should == []
  end

  it "should create a past page after a change" do
    PreviousPage.count.should == 0
    tmp = page.content

    page.change_content(user: user, content: ' xxx ')
    PreviousPage.count.should == 1
    pp = PreviousPage.first

    pp.title.should == page.title
    pp.content.should == tmp

    pp.page.should == page
    pp.user.should == user
  end

  it "should have one past page after one change"  do
    page.change_content(user: user, content: ' xxx ')
    page.history.count.should == 1
  end

  it "should have two past pages after two changes"  do
    page.change_content(user: user, content: ' xxx ')
    page.change_content(user: user, content: ' zzzz ')
    Page.first.history.count.should == 2
  end

  it "should only return its past pages" do
    user2 = FactoryGirl.create(:user)
    page2 = FactoryGirl.create(:page,user: user2)
    original_page_content = page.content
    original_page2_content = page2.content

    page.change_content(user: user, content: 'page content')
    page.change_content(user: user2, content: 'not tested')
    page2.change_content(user: user2, content: 'also not tested')

    page.history[0].content.should == 'page content'
    page.history[1].content.should == original_page_content

    page2.history[0].content.should == original_page2_content
  end





=begin

  it "should provide a change history after update" do
    @page.new_title_and_or_content(user: user, content: ' xxx ')
    @page.history.should == [FactoryGirl.create(:previous_page,
                                                page: self, user: user, title: @page.title, content: 'xxx')]
  end
=end

end





