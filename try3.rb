require 'spec_helper'

class Try
  def initialize
    @ld =[ ['MU5', :isa, 'Computer'],
           ['atlas', :isa, 'Computer'],
           ['MU6G', :isa, 'Computer'],
           ['The baby', :isa, 'Computer'],
           ['Manchester Mark 1', :isa, 'Computer'],
           ['Hardware', :is_part_of, 'Computer'],
           ['Software', :is_part_of, 'Computer'],
           ['Memory', :is_part_of, 'Hardware'],
           ['Disc Drive', :is_part_of, 'Hardware'],
           ['CPU', :is_part_of, 'Hardware'],
           ['zorg', :isa, 'atlas'],
           ['zorb', :isa, 'atlas'],
           ['zort', :isa, 'MU6G'] ]

  end
  def trail(arr, relation)
    arr = [arr] unless arr.class == :Array
    triple = :start_the_loop
    while triple
      triple = @ld.find{|t| t[0]==arr.last &&  t[1] == relation}
      arr << triple[2] if triple
    end
    arr.reverse
  end
  def inverse_set(cat_in, rel)
    cats = @ld.find_all{|t| t[1] == rel && t[2] == cat_in}
    res = cats.collect{|t| t[0]}
    p res
    #return nil if res == [] || res == nil
    #TODO sort put uniq - remove it and see what happens
    ret = [cat_in].concat(res.concat(res.each.collect{|c| inverse_set(c, rel)}.flatten.reject{|c| c == nil})).uniq
  end
end


class Page
  def initialize
    @page_category = 'atlas'
  end
  def is_in_category(cat, rooter)
    rooter.ld_trail(@page_category, :isa).include?(cat)
  end
end


describe Try do
  before(:each) do
    @rooter = Try.new
    @p = Page.new
  end

  it 'should return the inverse set' do
    @rooter.inverse_set('Computerx', :isa).should == 0
  end
end


=begin



  it "should return trails" do
    @rooter.trail('zorb', :isa).should == ["Computer", "atlas", "zorb"]
  end
  it "should identify if in categories" do
    @p.is_in_category('Computer', @rooter).should == true
    @p.is_in_category('noway', @rooter).should == false
  end
end

def get_next(start_token, relation)
    res = @ld.find_all{|triple| triple[0]==start_token &&  triple[1] == relation}.collect{|triple|triple[2]}
    res == [] ? nil : res
end

  def all( relation, token)
    result = @ld.find_all{|triple| triple[1] == relation && triple[2]==token }.each.collect{|triple| triple[0]}
    if result == []
      nil
    else
      result.each{|t| rsub = all(:isa, t); result.concat(rsub) if rsub }
    end
  end
=end



=begin
  it "should process ld" do
    @rooter.all(:isa, 'Computer').should ==
        ["MU5", "atlas", "MU6G", "The baby", "Manchester Mark 1", "zorg", "zorb", "zort"]
  end
  it "should process ld" do
    @rooter.get_next('zorg', :isa).should == ["atlas"]
  end
=end
