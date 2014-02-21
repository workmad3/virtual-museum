require 'spec_helper'

RSpec.configure do |config|
  config.include(UserAndPageHelpers)
end

describe 'Previous Page' do
    before(:each) do
      user
      page
      @previous_page = FactoryGirl.create(:page_state, page: page, user: user)
    end

  it { @previous_page.should validate_presence_of(:page_id) }
  it { @previous_page.should belong_to(:page) }

  it { @previous_page.should validate_presence_of(:user_id) }
  it { @previous_page.should belong_to(:user) }

  it 'should do something' do

    true.should == false
  end
end
