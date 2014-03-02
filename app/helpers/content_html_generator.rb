#require 'parslet'
require 'parsing/content_parser'
require 'parsing/content_transformer'


class ContentHtmlGenerator
  def self.generate  pg
    parsed = ContentParser.new.parse(pg.content)
    pp '----------------------------------------------------'
    pp parsed
    pp '----------------------------------------------------'
    output_array = ContentTransformer.new.apply(parsed)
    output_string = ''
    output_array.each { |str| output_string = output_string + str }
    pp output_string
    pp '----------------------------------------------------'
    output_string
  end
end