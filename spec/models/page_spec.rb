require 'spec_helper'

describe Page do
  before(:each) do
    DatabaseCleaner.clean
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page, user: @user)
    @history = [@page.content]
    subject { @page }
  end

  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }

  it "should have no previous pages after creation" do
    Page.first.history.should == []
    end

  it "should create a history record after a change" do
    PreviousPage.count.should == 0
    tmp = @page.content
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    PreviousPage.count.should == 1
    pp= PreviousPage.first
    pp.page.should == @page
    pp.user.should == @user
    pp.title.should == @page.title
    pp.content.should == tmp
  end

  it "should return one past page after a change"  do
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    Page.first.history.count.should == 1
  end

  it "should return two past pages after two changes"  do
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    @page.new_title_and_or_content(user: @user, title: ' zzzz ')
    Page.first.history.count.should == 2
  end

  it "should only return its prev pages" do
    user2 = FactoryGirl.create(:user)
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    @page.new_title_and_or_content(user: user2, title: ' zzzz ')
    Page.first.history.count.should == 2
  end


  it "should change content" do
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    @page.content.should == ' xxx '
  end

  it "should change title" do
    @page.new_title_and_or_content(user: @user, title: ' xxx ')
    @page.title.should == ' xxx '
  end


=begin

  it "should provide a change history after update" do
    @page.new_title_and_or_content(user: @user, content: ' xxx ')
    @page.history.should == [FactoryGirl.create(:previous_page,
                                                page: self, user: @user, title: @page.title, content: 'xxx')]
  end
=end

end





