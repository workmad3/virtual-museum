# http://www.sitepoint.com/parsing-parslet-gem/

require 'parslet'

class DemoParser < Parslet::Parser
  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }
  rule(:ref_text) { match('[a-zA-Z0-9 ]').repeat(1) }
  rule(:text) { match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|]').repeat(1) }
  rule(:pair) { open_bracket >> ref_text.as(:ref) >> close_bracket >> text.as(:text).maybe }
  #rule(:pair) { reference  }
  rule(:start) {  text.as(:text) | match(' ').repeat(0) }
  rule(:pairs) { start >> pair.repeat(0) }

  root(:pairs)
end

demo_parser = DemoParser.new
result = demo_parser.parse(" xxxxxxxxxxxxxxxxxxxxxxx[a][bb]   1111 [b][cuddly bears]xxxx")
result.each { |thing|  puts "REF #{thing[:ref]}" if thing.has_key?(:ref) ; puts "TXT #{thing[:text]}" if thing.has_key?(:text)}


#p result