# http://www.sitepoint.com/parsing-parslet-gem/
require './lib/parsing/link_interpreter'
require 'parslet'
require 'pp'

class Page
  def self.find_by_title arg
    'SOMEURL'
  end
end

class DemoTransformer < Parslet::Transform
  rule(:start => simple(:start)) { '<p>' }

  rule(:text => simple(:text)) { text.to_s }
  rule(:esc => simple(:esc)) { esc.to_s }
  rule(:contents => simple(:contents)) do
    li = LinkInterpreter.new(contents.to_s)
    li.process_bracket_contents
  end

  rule(:end => simple(:end)) { '</p>' }
end

class DemoParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(1) }
  rule(:space?) { space.maybe }

  rule(:escaped_char) { str('\\') >> any.as(:esc) }

  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }

  rule(:contents_text) { match('[a-zA-Z0-9 \:\\\/\. \-\_]').repeat(1) }
  rule(:contents) { open_bracket >> contents_text.as(:contents) >> close_bracket }


  rule(:text_char) { match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|\]]') }
  rule(:text) { text_char.repeat(1) }

  rule(:element) { text.as(:text)| contents | escaped_char }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end) }

  root(:elements)
end

demo_parser = DemoParser.new
result = demo_parser.parse("xxxx [http://hedtek.com] iiii")

pp result
result = DemoTransformer.new.apply(result)
pp result
#result.each { |thing|  puts "#{thing[:type]}  #{thing[:value]}"  }
