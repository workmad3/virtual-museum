#require 'parslet'
require 'parsing/content_parser'
require 'parsing/content_transformer'

class ContentHtmlGenerator
  def self.generate(page)
    parsed = ContentParser.new.parse(page.content)
    ContentTransformer.new.apply(parsed).join(' ')
  end
end