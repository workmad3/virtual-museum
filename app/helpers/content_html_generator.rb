#require 'parslet'
require 'parsing/content_parser'
require 'parsing/content_transformer'


class ContentHtmlGenerator
  def self.generate  pg
    parsed = ContentParser.new.parse(pg.content)
    ContentTransformer.new.apply(parsed)
  end
end