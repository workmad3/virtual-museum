require 'spec_helper'

RSpec.configure do |config|
  config.include(UserAndPageHelpers)
end

describe Page do
  before(:each) do
    user
    page
    page2
    subject { page }
  end

=begin

  it 'return content that is unchanged if here are no page references' do
    page.content = 'some content here'
    page.slugged_content.should == [ text: 'some content here']
  end

  it 'make a substitution for one page references' do
    page.content = "some content [#{page2.title}] here"
    page.slugged_content.should == [ text:      'some content ',
                                     reference: [page2.slug, page2.title],
                                     text:      ' here' ]
  end

  it 'make substitutions for two page references' do
    page.content = "some content [#{page2.title}] here [#{page2.title}] there"
    s =  "some content [#{page2.slug}] here [#{page2.slug}] there"
    page.slugged_content.should == [ text:      'some content ',
                                     reference: [page2.slug, page2.title],
                                     text:      ' here ',
                                     reference: [page2.slug, page2.title],
                                     text:      ' there' ]
  end

=end

  #------------------------------------------------------------------------------------------------


  it 'parse content that has no page references' do
    to_parse = 'some content here'
    page.parse_content(to_parse).should == [{text: 'some content here'}]
  end

  it 'parse content that has one page reference' do
    to_parse = "some [#{page.title}] content here"
    page.parse_content(to_parse).should == [{text: 'some '},
                                            {link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}},
                                            {text: ' content here'}]

    to_parse = "[#{page.title}] content here"
    page.parse_content(to_parse).should == [{link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}}, {text: ' content here'}]

    to_parse = "some [#{page.title}]"
    page.parse_content(to_parse).should == [{text: 'some '}, {link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}}]

    to_parse = "[#{page.title}]"
    page.parse_content(to_parse).should == [{link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}}]
  end


  it 'parse content that has two page references' do
    to_parse = "some [#{page.title}] content [#{page2.title}] here"
    page.parse_content(to_parse).should ==
        [{text: 'some '},
         {link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}},
         {text: ' content '},
         {link: {title: "#{page2.title}", slug: "#{page2.slug}", exists: true}},
         {text: ' here'}]

    to_parse = "[#{page.title}] [#{page2.title}]"
    page.parse_content(to_parse).should ==
        [{link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}},
         {text: ' '},
         {link: {title: "#{page2.title}", slug: "#{page2.slug}", exists: true}}]

    to_parse = "[#{page.title}][#{page2.title}]"
    page.parse_content(to_parse).should ==
        [{link: {title: "#{page.title}", slug: "#{page.slug}", exists: true}},
         {link: {title: "#{page2.title}", slug: "#{page2.slug}", exists: true}}]

=begin
    to_parse = '[the ref] content [other ref] here'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {text: ' content '}, {link: 'other ref'}, {text: ' here'}]

    to_parse = 'some [the ref] content [other ref]'
    p = page.parse_content(to_parse).should ==
        [{text: 'some '}, {link: 'the ref'}, {text: ' content '}, {link: 'other ref'}]

    to_parse = '[the ref] content [other ref]'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {text: ' content '}, {link: 'other ref'}]
=end
  end


  it 'should split the empty string' do
    to_parse = ''
    p = page.split_string(to_parse).should == ['', '', '']
  end
  it 'should split with no refs' do
    to_parse = 'some content here'
    p = page.split_string(to_parse).should == ['', 'some content here', '']
  end
  it 'should split with only a ref' do
    to_parse = '[the ref]'
    p = page.split_string(to_parse).should == ['', '[the ref]', '']
  end
  it 'should split with a ref and text on each side' do
    to_parse = 'some [the ref] content here'
    p = page.split_string(to_parse).should == ['some ', '[the ref]', ' content here']
  end
  it 'should split with a ref and spaces on each side' do
    to_parse = ' [the ref] '
    p = page.split_string(to_parse).should == [' ', '[the ref]', ' ']
  end
  it 'should split with two refs spaced apart' do
    to_parse = ' [the ref] [other ref]'
    p = page.split_string(to_parse).should == [' ', '[the ref]', ' [other ref]']
  end
  it 'should split with only two refs' do
    to_parse = '[the ref][other ref]'
    p = page.split_string(to_parse).should == ['', '[the ref]', '[other ref]']
  end
  it 'should tokenize' do
    page.tokenize('strr').should == {text: 'strr'}
  end
=begin
  it 'should tokenize' do
    page.tokenize('[strr]').should == {link: 'strr'}
  end
  it 'should downcase the target / new'  do
    page.tokenize('[Strr]')[:link][:title].should == 'strr'
  end
=end
  it 'should link tokenize' do
    page.tokenize("[#{page2.title}]").should == {link: {
        title: page2.title,
        slug: page2.slug,
        exists: true
    }}
    page.tokenize('[Doesnt exist title]').should == {link: {
        title: 'Doesnt exist title',
        slug: 'Doesnt-exist-title---not-created-yet',
        exists: false
    }}
  end
end
