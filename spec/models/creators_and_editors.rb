require 'spec_helper'

describe Page do


  end

  before(:each) do
    user
    page
    user2
    page2
    subject { page }
  end

  it "creator should be set when page first created" do
    page.user.should == user2
    page2.user.should == user
  end
end
