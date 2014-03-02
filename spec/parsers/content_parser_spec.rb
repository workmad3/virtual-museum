require 'spec_helper'
require './lib/parsing/content_parser'

describe ContentParser do
  it "should deal with a plain string" do
    str = 'this is a string'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start=>nil}, {:text=>"this is a string"}, {:end=>nil}]
  end
  it "should deal with a page hyperlink"  do
    str = 'this is a [hyperlinked] string'
    parsed = ContentParser.new.parse(str)
    parsed.should ==    nil
  end
  it "should deal with a youtube url" do
    str = 'this is from youtube [http://www.youtube.com/watch?v=H9VBIOtklkQ] end'
    parsed = ContentParser.new.parse(str)
    parsed.should ==    nil
  end
end