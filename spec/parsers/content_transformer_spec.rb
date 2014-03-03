require 'spec_helper'
require './lib/parsing/content_parser'
require './lib/parsing/content_transformer'


describe ContentTransformer do
  it "should deal with a plain string" do
    str = 'this is a string'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == '<p> this is a string </p>'
  end

  it "should deal with bracket contents to be inlined" do
    str = 'this is a [hyperlinked] string'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == "<p> this is a  <a href='/pages/new?page_title=hyperlinked' data-new-page>hyperlinked</a>  string </p>"
  end

  it "should deal with bracket contents not to be inlined" do
    str = 'ahead [http://www.youtube.com/watch?v=V02MOxRcxCM] behind'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == "<p> ahead  </p><div><iframe width=\"420\" height=\"315\" src=\"//www.youtube.com/embed/V02MOxRcxCM\" frameborder=\"0\" allowfullscreen></iframe></div><p>  behind </p>"
  end

#TODO really there should be tests for the inlined hyperlink cases as well, as per the following three inlined examples

  it "should deal with no plain text before the (non-inlined) hyperlink brackets" do
    str = '[http://www.youtube.com/watch?v=V02MOxRcxCM] behind'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == "<p> </p><div><iframe width=\"420\" height=\"315\" src=\"//www.youtube.com/embed/V02MOxRcxCM\" frameborder=\"0\" allowfullscreen></iframe></div><p>  behind </p>"
  end

  it "should deal with no plain text after the (non-inlined) hyperlink brackets" do
    str = 'ahead [http://www.youtube.com/watch?v=V02MOxRcxCM]'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == "<p> ahead  </p><div><iframe width=\"420\" height=\"315\" src=\"//www.youtube.com/embed/V02MOxRcxCM\" frameborder=\"0\" allowfullscreen></iframe></div><p> </p>"
  end

  it "should deal with (non-inlined) hyperlink brackets alone" do
    str = '[http://www.youtube.com/watch?v=V02MOxRcxCM]'
    parsed = ContentParser.new.parse(str)
    transformed = ContentTransformer.new.apply(parsed).join(' ')
    transformed.should == "<p> </p><div><iframe width=\"420\" height=\"315\" src=\"//www.youtube.com/embed/V02MOxRcxCM\" frameborder=\"0\" allowfullscreen></iframe></div><p> </p>"
  end

end
