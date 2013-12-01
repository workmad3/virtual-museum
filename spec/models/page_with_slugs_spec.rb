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

=begin
  it 'parse content that has no page references' do
    to_parse = 'some content here'
    page.parse_content(to_parse).should == [{text: 'some content here'}]
  end

  it 'parse content that has one page reference' do
    to_parse = 'some [the ref] content here'
    p = page.parse_content(to_parse).should == [{text: 'some '}, {link: 'the ref'}, {text: ' content here'}]

    to_parse = '[the ref] content here'
    page.parse_content(to_parse).should == [{link: 'the ref'}, {text: ' content here'}]

    to_parse = 'some [the ref]'
    page.parse_content(to_parse).should == [{text: 'some '}, {link: 'the ref'}]

    to_parse = '[the ref]'
    page.parse_content(to_parse).should == [{link: 'the ref'}]
  end


  it 'parse content that has two page references' do
    to_parse = 'some [the ref] content [other ref] here'
    p = page.parse_content(to_parse).should ==
        [{text: 'some '}, {link: 'the ref'}, {text: ' content '}, {link: 'other ref'}, {text: ' here'}]

    to_parse = '[the ref] content [other ref] here'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {text: ' content '}, {link: 'other ref'}, {text: ' here'}]

    to_parse = 'some [the ref] content [other ref]'
    p = page.parse_content(to_parse).should ==
        [{text: 'some '}, {link: 'the ref'}, {text: ' content '}, {link: 'other ref'}]

    to_parse = '[the ref] content [other ref]'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {text: ' content '}, {link: 'other ref'}]

    to_parse = '[the ref] [other ref]'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {text: ' '}, {link: 'other ref'}]

    to_parse = '[the ref][other ref]'
    p = page.parse_content(to_parse).should ==
        [{link: 'the ref'}, {link: 'other ref'}]


  end
=end

  it 'should split' do
    to_parse = 'some content here'
    p = page.split_string(to_parse).should == ['', 'some content here', '']
  end
  it 'should split' do
    to_parse = '[the ref]'
    p = page.split_string(to_parse).should == ['', '[the ref]', '']
  end
  it 'should split' do
    to_parse = 'some [the ref] content here'
    p = page.split_string(to_parse).should == ['some ', '[the ref]', ' content here']
  end
  it 'should split' do
    to_parse = ' [the ref] '
    p = page.split_string(to_parse).should == [' ', '[the ref]', ' ']
  end
end
