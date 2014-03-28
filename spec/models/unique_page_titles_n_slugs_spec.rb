require 'spec_helper'

describe 'Pages with unique titles' do

  def make_page_with_title (title)
    user = FactoryGirl.create(:user)
    page = FactoryGirl.create(:page, original_title: title )
    page_state = FactoryGirl.create(:page_state, title: page.original_title, content: 'the content',
                                     user: user, page: page)
  end

  before(:each) do
    make_page_with_title('Title one')
    make_page_with_title('Title two')
    make_page_with_title('Used title')
    make_page_with_title('Title four')
  end


end