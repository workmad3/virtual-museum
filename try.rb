# http://www.sitepoint.com/parsing-parslet-gem/

require 'parslet'

class DemoParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(1) }
  rule(:space?) { space.maybe }
  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }
  rule(:escaped_open_bracket) { str('\\[').as(:open_bracket) }
  rule(:escaped_close_bracket) { str('\\]').as(:close_bracket) }
  rule(:ref_text) { match('[a-zA-Z0-9 ]').repeat(1) }
  rule(:ref) { open_bracket >> ref_text.as(:ref) >> close_bracket  }


  rule(:text_char) { match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|]') | escaped_open_bracket | escaped_close_bracket }
  rule(:text) { text_char.repeat(1) }

  rule(:pair)  { ref >> text.as(:text).maybe }
  rule(:start) { text.as(:text) | match(' ').repeat(0) }
  rule(:pairs) { start >> pair.repeat(0) }

  root(:pairs)

  def tokenise arg
    untokenised = parse arg

    #puts untokenised
    tokenised = Array.new
    if untokenised.class == Hash
      tokenised[0] = {type: :TEXT, value: untokenised[:text].to_s  }
      puts tokenised[0][:value]
    else
      untokenised.each do |thing|
        tokenised << {type: :REF, value: thing[:ref].to_s  } if thing.has_key?(:ref)

        tokenised << {type: :TXT, value: thing[:text].to_s  } if thing.has_key?(:text)
      end
    end
    tokenised
  end
end

class DemoTransformer < Parslet::Transform
  rule(:text => simple(:text)) { p text }
  rule(:open_bracket) {'['}
  rule(:close_bracket) {']'}
  rule(:ref => simple(:ref)) { p ref }
end

demo_parser = DemoParser.new
result = demo_parser.tokenise(" ccc[page xxxxxxxxxxxxxxxxxxxxxxx][hello there]x \\[\\]x [subject] ")
#result = DemoTransformer.new.apply(result)
puts result
#result.each { |thing|  puts "#{thing[:type]}  #{thing[:value]}"  }
