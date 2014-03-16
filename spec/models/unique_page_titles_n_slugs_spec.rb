require 'spec_helper'

describe 'Pages with unique titles' do

=begin
  def user() @user end
  def page() @page end
  def page_state() @page_state end
=end
  def make_page_with_title (title)
    user = FactoryGirl.create(:user)
    page = FactoryGirl.create(:page, title )
    page_state = FactoryGirl.create(:page_state, title: page.original_title, content: 'the content',
                                     user: user, page: page)
  end

  before(:each) do
=begin
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page, title )
    @page_state = FactoryGirl.create(:page_state, title: page.original_title, content: 'the content',
                                     user: user, page: page)
=end
    make_page_with_title('Title one')
    make_page_with_title('Title two')
    make_page_with_title('Used title')
    make_page_with_title('Title four')
  end


  it "should return false if a title is not used" do
    Pages.title_used?('Unused title').should == 'xx'
  end


  it "should return true if a title is used" do
    Pages.title_used?.should == 'xx'
  end
end