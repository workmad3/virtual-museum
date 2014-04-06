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
end

class Page
  def initialize
    @page_category = 'zorg'
  end
  def is_in_category(cat, rooter)
    p rooter.trail(@page_category, :isa).include?(cat)
    rooter.trail(@page_category, :isa).include?(cat)
  end
end


describe Try do
  before(:each) do
    @rooter = Try.new
    @p = Page.new
  end

  it "should return trails" do
    @rooter.trail('zorb', :isa).should == ["Computer", "atlas", "zorb"]
  end
  it "should identify if in categories" do
    @p.is_in_category('Computer', @rooter).should == true
    @p.is_in_category('noway', @rooter).should == false
  end
end

=begin
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
