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
  it { Page.count.should == 1}
  it { User.count.should == 1}
  it { @page.update(content: 'xxx'); @page.content.should == 'xxx'}

  it "should provide a change history after update" do

    Page.first.history.should == @history
    @page.update(content: 'xxx')
    @page.history.should == [@history[0], 'xxx']
  end

end





