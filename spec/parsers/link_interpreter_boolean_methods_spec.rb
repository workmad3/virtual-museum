require 'spec_helper'
require './lib/parsing/link_interpreter'

describe LinkInterpreter do
  it "should recognise a URL" do
    li = LinkInterpreter.new('http://hedtek.com')
    li.url?.should be_true
    li = LinkInterpreter.new('http://www.hedtek.com')
    li.url?.should == true
    li = LinkInterpreter.new('http://hedtek.com/')
    li.url?.should == true
    li = LinkInterpreter.new('http://hedtek.com/xx')
    li.url?.should == true
    li = LinkInterpreter.new('http://hedtek.com/xx/y-y')
    li.url?.should == true
    li = LinkInterpreter.new('http://hedtek.com/xx/y-y/img.png')
    li.url?.should == true
  end

  it "should recognise a bad URL 1" do
    li = LinkInterpreter.new('http:/hedtek.com')
    li.url?.should == false
  end

  it "should recognise a bad URL 2" do
    li = LinkInterpreter.new('ftp://hedtek.com')
    expect(li.url?).to be_false
  end

  #TODO think about the phrasing above

  it "should recognise a bad URL 3" do
    li = LinkInterpreter.new('http://hedtek..com')
    li.url?.should == false
  end
  it "should recognise a bad URL 4" do
    li = LinkInterpreter.new('http:/hedtek.com')
    li.url?.should == false
  end

  it "should recognise url suffix" do
    li = LinkInterpreter.new('http://hedtek.com/x')
    li.url_suffix?.should == true
  end
  it "should recognise no url suffix" do
    li = LinkInterpreter.new('http://hedtek.com/')
    li.url_suffix?.should == false
    li = LinkInterpreter.new('http://hedtek.com/')
    li.url_suffix?.should == false
  end

  it "should recognise an image url" do
    li = LinkInterpreter.new('http:/hedtek.com/x/u/img.png')
    li.image_url?.should == false
    li = LinkInterpreter.new('http:/hedtek.com/image.jpg')
    li.image_url?.should == false
  end
  it "should recognise a bad image URL 1" do
    li = LinkInterpreter.new('http:/hedtek.png')
    li.url?.should == false
  end
  it "should recognise a bad image URL 2" do
    li = LinkInterpreter.new('http:/hedtek.com/movie.mp4')
    li.url?.should == false
  end
  it "should extract domain" do
    li = LinkInterpreter.new('http://hedtek.com/movie.mp4')
    li.domain.should == 'hedtek.com'
    li = LinkInterpreter.new('http://hedtek.com/')
    li.domain.should == 'hedtek.com'
    li = LinkInterpreter.new('http://hedtek.com')
    li.domain.should == 'hedtek.com'
    li = LinkInterpreter.new('http://www.hedtek.com/')
    li.domain.should == 'www.hedtek.com'
  end

  it "should recognise a given domain" do
    li = LinkInterpreter.new('http://hedtek.com')
    li.is_domain?('hedtek.com').should == true
  end
  it "should recognise not a given domain" do
    li = LinkInterpreter.new('http://hedtek.com')
    li.is_domain?('sefol.com').should == false
  end

  it "should recognise a youtube URL" do
    li = LinkInterpreter.new('http://youtube.com')
    li.is_youtube_url?.should == true
    li = LinkInterpreter.new('http://www.youtube.com')
    li.is_youtube_url?.should == true
  end
  it "should recognise a non youtube URL" do
    li = LinkInterpreter.new('http://hedtek.com')
    li.is_youtube_url?.should == false
  end


end
