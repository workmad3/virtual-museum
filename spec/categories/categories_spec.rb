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

  it 'should be available' do
    page.ld_page_type.should == [["CollectionItem", :isa, "Page Type"], ["Person", :isa, "Page Type"], ["Resource", :isa, "Page Type"]]
  end

  it 'should have the right categories set' do
    page.categories.should == 'Zorg'
    page.categories = 'Zorg, Atlas'
    page.categories.should == 'Atlas, Zorg'

  end
  it 'should get the right trail' do
    page.ld_trail(page.categories, :isa).should == [ 'Computer', 'Atlas', 'Zorg']
  end
  it 'should get the right trails' do
    page.ld_trails('Zorg', :isa).should ==       [ [ 'Computer', 'Atlas', 'Zorg'] ]
    page.ld_trails('MU6G, Zorg', :isa).should == [ [ 'Computer', 'MU6G'],[ 'Computer', 'Atlas', 'Zorg']  ]
  end
  it 'should assert transitive predicates' do
    page.ld_assert( 'Zorg', :isa, 'Computer' ).should == true

    page.ld_assert( 'Computer', :isa, 'Zorg' ).should == false
    page.ld_assert( 'Zorg', :isa, 'Zorg' ).should == false

    page.ld_assert( 'xx', :isa, 'Computer' ).should == false
    page.ld_assert( 'Zorg', :isa, 'xx' ).should == false
  end
  it 'should find the inverse set' do
    page.ld_inverse_set('Zorg', :isa).should == ['Zorg']
    page.ld_inverse_set('Atlas', :isa).should == ['Atlas', 'Zorg', 'Zorb']
    page.ld_inverse_set('Computer', :isa).should == ["Computer", "MU5", "Atlas", "MU6G", "The baby", "Manchester Mark 1", "Zorg", "Zorb", "Zort"]
  end
  it 'should find pages in the inverse set' do
    page.ld_page_in_inverse_set('Zorg', :isa).should == true
    page.ld_page_in_inverse_set('Computer', :isa).should == true
    page.ld_page_in_inverse_set('MU6G', :isa).should == false
    page.categories = 'c1, MU6G'
    page.save
    page.categories.should == 'c1, MU6G'
    page.ld_page_in_inverse_set('MU6G', :isa).should == true
    page.ld_page_in_inverse_set('Atlas', :isa).should == false
    page.categories = 'c1'
    page.save
    page.ld_page_in_inverse_set('Atlas', :isa).should == false

  end

end