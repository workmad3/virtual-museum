require 'spec_helper'

describe 'Previous Page' do

  def user() @user end
  def page() @page end
  def page_state() @page_state end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page)
    @page_state = FactoryGirl.create(:page_state, title: page.original_title, content: 'the content',
                                     user: user, page: page, tags: 'tag1, tag2')
  end

  it { page_state.should validate_presence_of(:page_id) }
  it { page_state.should belong_to(:page) }

  it { page_state.should validate_presence_of(:user_id) }
  it { page_state.should belong_to(:user) }

  it "should return the correct title" do
    page_state.title.should == page.original_title
  end


  it "should return the correct content" do
    page_state.content.should == 'the content'
  end

  it "should return the tags" do
    page_state.tags.should == 'tag1, tag2'
    page_state.tags = 'tag3'
    page_state.tags.should == 'tag3'
  end
end