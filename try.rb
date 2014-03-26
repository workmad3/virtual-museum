# http://www.sitepoint.com/parsing-parslet-gem/
require './lib/parsing/link_interpreter'
require 'parslet'
require 'pp'

class Page
  def self.find_by_title arg
    'SOMEURL'
  end
end

class ContentTransformer < Parslet::Transform

  rule(:start => simple(:start)) { '<p>' }

  rule(:newline => simple(:newline)) { ''}

  rule(:text => simple(:text)) { text.to_s }

  rule(:esc => simple(:esc)) { esc.to_s }

  #TODO not bothered about empty paras atm
  #TODO but could factor out li#output_type by seeing if output starts <div> -- hmm  is this wise to do?

  rule(:contents => simple(:contents)) do
    li = LinkInterpreter.new(contents.to_s)
    output = li.process_bracket_contents
    if li.output_type == :in_line_hyperlink
      output
    else
      '</p>' + output + '<p>'
    end
  end

  rule(:end => simple(:end)) { '</p>' }

end

class ContentParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(0) }
  rule(:space?) { space.maybe }

  rule(:newline) { str("*[[[").as(:newline) }
  #rule(:escaped_char) { str('\\') >> any.as(:newline) }

  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }

  rule(:text) { match('[a-zA-Z0-9 \:\/\. \-\_\?\=\.,:{}<>\'\"\+\-!@#\$\%^&\(\)\~\`\|`]').repeat(1) }
  rule(:contents) { open_bracket >> text.as(:contents) >> close_bracket }

  rule(:element) { text.as(:text)| contents } # | escaped_char }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end) }

  rule(:paragraphs) { elements >> (newline >> elements).repeat(0) >> newline.repeat(0) }

  root(:paragraphs)
end

begin
  demo_parser = ContentParser.new
  str = "xxxx [http://hedtek.com word] niiii second*[[[ line"
  puts str
  result = demo_parser.parse(str)
  pp result
  result = ContentTransformer.new.apply(result).join
  p result
  #result.each { |thing|  puts "#{thing[:type]}  #{thing[:value]}"  }
end



