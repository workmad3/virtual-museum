#require 'parslet'
require 'parsing/content_parser'
require 'parsing/content_transformer'

class ContentHtmlGenerator
  def self.generate(page)
    arry_of_paragraphs = page.content.split("\r\n\r\n").collect do |s|
      s.gsub!(/\r\n/, ' ')
      if s.strip != ''
        begin
          parsed_para = ContentParser.new.parse(s)
          ContentTransformer.new.apply(parsed_para)
        rescue
          #TODO It seems ridiculous to show HTML here, even if the content transformer above makes it
          "<p yellow-background>Fix this paragraph: #{s}</p>"
        end

      end
    end
    arry_of_paragraphs.join('    ')
    #page.content
  end
end