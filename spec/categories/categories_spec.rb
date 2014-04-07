require 'spec_helper'

describe 'xx' do

  def page
    @page
  end
  before(:each) do
    @page = FactoryGirl.build(:page, categories: 'Zorg')
    @page.save
    subject {@page}
  end

  it 'should have the right categories set' do
    page.categories.should == 'Zorg'
  end
  it 'should get the right trail' do
    Page.trail(page.categories, :isa).should == ["ROOT", "Computer", "Atlas", "Zorg"]
  end
end