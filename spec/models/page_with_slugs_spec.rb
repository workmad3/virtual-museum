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

  it 'return content that is unchanged if here are no page references' do
    page.content = "some content here"
    page.slugged_content.should == "some content here"
  end

  it 'make a substitution for one page references' do
    page.content = "some content [#{page2.title}] here"
    page.slugged_content.should == "some content [#{page2.slug}] here"
  end

  it 'make substitutions for two page references' do
    page.content = "some content [#{page2.title}] here [#{page2.title}] there"
    s =  "some content [#{page2.slug}] here [#{page2.slug}] there"
    page.slugged_content.should == s
  end

end