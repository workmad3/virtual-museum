require 'spec_helper'
require './lib/parsing/content_parser'

describe ContentParser do
  it "should deal with a plain string" do
    str = 'this is a string'
    parsed = ContentParser.new.parse(str)
    puts parsed[1][:text].line_and_column.class
    puts parsed[1][:text].line_and_column.to_s
    puts parsed[1][:text].offset.to_s

    #TODO a pretty schleppy example of what one has to do to create a Parselet::Slice
    parsed.should == [{:start => ''}, {:text => Parslet::Slice.new("this is a string", 0, [1,1])}, {:end => ''}]
  end

  it "should deal with a string with angle barackets" do
    str = '<script></script>this <is> a string'
    parsed = ContentParser.new.parse(str)

    #TODO the kludge to fix schlep, less brittle I think, but i dont know what the tuple is for in the Slice
    parsed[1][:text] = parsed[1][:text].to_s
    parsed.should == [{:start => ''}, {:text => "<script></script>this <is> a string"}, {:end => ''}]
  end

  it "should deal with bracket contents that are a page hyperlink" do
    str = 'this is a [hyperlinked] string'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:text => "this is a "},
                      {:contents => "hyperlinked"}, {:text => " string"}, {:end => nil}]
  end

  it "should deal with bracket contents that comprise an http URL" do
    str = 'this is from youtube [http://www.youtube.com/watch?v=H9VBIOtklkQ] end'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:text => "this is from youtube "},
                      {:contents => "http://www.youtube.com/watch?v=H9VBIOtklkQ"}, {:text => " end"}, {:end => nil}]
  end

  it "should deal with bracket contents that comprise an https URL" do
    str = 'this is from secure site [https://www.secure.com] end'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:text => "this is from secure site "},
                      {:contents => "https://www.secure.com"}, {:text => " end"}, {:end => nil}]
  end

  it "should deal with bracket contents that comprise a URL and some text" do
    str = 'this is from secure site [https://www.secure.com splishsplat] end'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:text => "this is from secure site "},
                      {:contents => "https://www.secure.com splishsplat"}, {:text => " end"}, {:end => nil}]
  end

  it "should deal with no plain text before the hyperlink brackets" do
    str = '[hyperlinked] string'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil},
                      {:contents => "hyperlinked"}, {:text => " string"}, {:end => nil}]
  end

  it "should deal with no plain text after the hyperlink brackets" do
    str = 'this is a [hyperlinked]'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:text => "this is a "},
                      {:contents => "hyperlinked"}, {:end => nil}]
  end

  it "should deal with hyperlink brackets alone" do
    str = '[hyperlinked]'
    parsed = ContentParser.new.parse(str)
    parsed.should == [{:start => nil}, {:contents => "hyperlinked"}, {:end => nil}]
  end

end
