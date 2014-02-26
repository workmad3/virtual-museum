# http://www.sitepoint.com/parsing-parslet-gem/

require 'parslet'

class DemoParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(1) }
  rule(:space?) { space.maybe }
  rule(:open_bracket) { match('\{') }
  rule(:close_bracket) { match('\}') }

  rule(:ref_text) { match('[a-zA-Z0-9 ]').repeat(1) }
  rule(:ref) { open_bracket >> ref_text.as(:ref) >> close_bracket  }


  rule(:text_char) { match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|\[\]]') }
  rule(:text) { text_char.repeat(1) }

  rule(:element)  { text.as(:text)| ref }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end)}

  root(:elements)

end

class Page
  def self.find_by_title arg
    nil
  end
end

class DemoTransformer < Parslet::Transform
  rule(:start => simple(:start)) { '<p>' }
  rule(:text => simple(:text)) { text.to_s }
  rule(:ref => simple(:ref)) do
      url_ending = Page.find_by_title(ref.to_s)
      if url_ending
        "<a href='/pages/#{url_ending}' style='color: #0000FF'>#{ref.to_s}</a>"
      else
        ref.to_s
      end
  end

  rule(:end => simple(:end)) { '</p>' }
end

demo_parser = DemoParser.new
result = demo_parser.parse(" ccc{page title} {hello there}x x [1] ")
result = DemoTransformer.new.apply(result)
puts result
#result.each { |thing|  puts "#{thing[:type]}  #{thing[:value]}"  }
