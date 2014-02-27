#require 'parslet'
require 'parsing/content_parser'
require 'parsing/content-transformer'


class ContentHtmlGenerator
  def self.generate  pg
    parsed = ContentParser.parse(pg.content)
    ContentTransformer.new.apply(parsed)
  end
end