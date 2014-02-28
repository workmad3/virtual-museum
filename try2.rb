require 'parslet'
require 'pp'

class JSON < Parslet::Parser
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }
  rule(:quote)      { str('"') }
  rule(:nonquote)   { str('"').absnt? >> any }
  rule(:comma)      { str(',') >> space? }
  rule(:colon)      { str(':') >> space? }
  rule(:escape)     { str('\\') >> any.as(:esc) }
  rule(:string)     { quote >> (
  escape |
      nonquote.as(:char)
  ).repeat(1).as(:str) >> quote }

  rule(:integer)    { match['0-9'].repeat(1).as(:int) >> space? }
  rule(:value)      { string | integer }
  rule(:array_list) { value >> (comma >> value).repeat }
  rule(:array)      { match['\['] >> array_list.as(:array) >> match['\]'] }
  rule(:hash_pair)  { string.as(:key) >> colon >> object.as(:value) }
  rule(:hash_list)  { hash_pair >> (comma >> hash_pair).repeat }
  rule(:hash)       { match['{'] >> hash_list.as(:hash) >> match['}'] }

  rule(:object)     { hash | array | string | integer }
  root :object
end

class JSON::Transform < Parslet::Transform
  rule(str: sequence(:chars)) { p chars.join; }
  rule(esc: simple(:esc)) { "e(#{esc})" }
  rule(char: simple(:char)) { "c(#{char})" }
end

def parse(klass, str)
  parser = klass.new
  puts "parsing #{str}"
  result = JSON::Transform.new.apply(parser.parse(str)).to_s
  puts
rescue Parslet::ParseFailed => err
  puts err, parser.root.error_tree
end

parse JSON, %("abc")
parse JSON, %(123)
parse JSON, %([1,2,3])
parse JSON, %({"a": 1, "b": 2, "c": [1,2,3], "d": ["a", "b"], "e": {"e": "\\"five\\""}})