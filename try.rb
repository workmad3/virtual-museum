# http://www.sitepoint.com/parsing-parslet-gem/

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
  rule(:esc => simple(:esc)) {esc.to_s}
  rule(:ref => simple(:ref)) do
      url_ending = Page.find_by_title(ref.to_s)
      if url_ending
        "<a href='/pages/#{url_ending}' style='color: #0000FF'>#{ref.to_s}</a>"
      else
        "<a href='/pages/#{url_ending}' style='color: #FF0000'>#{ref.to_s}</a>"
      end
  end
  def url_content

  end
  rule(:url =>  simple(:str)) do
    strx = str.to_s
    strx.strip!
    pp strx
    url, hyperlink_text = strx.split(/ /,2)
    hyperlink_text.strip! if hyperlink_text.length > 1
    hyperlink_text = "http://#{url}" if hyperlink_text == nil
    "<a href='http://#{url}' style='color: #0000FF'>#{hyperlink_text}</a>"
  end
  rule(:end => simple(:end)) { '</p>' }
end

class DemoParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(1) }
  rule(:space?) { space.maybe }

  rule(:escaped_char)     { str('\\') >> any.as(:esc) }

  rule(:open_bracket)  { match('\[') }
  rule(:close_bracket) { match('\]') }

  rule(:ref_text) { match('[a-zA-Z0-9 ]').repeat(1) }
  rule(:url_text) { match('[a-zA-Z0-9 \:\\\/\. ]').repeat(1) }
  rule(:url_str) { str('http\:\/\/')  }
  rule(:ref) { open_bracket >> ref_text.as(:ref) >> close_bracket  }
  rule(:url) { open_bracket >> str('http://') >> url_text.as(:url) >> close_bracket  }


  rule(:text_char) {  match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|\]]')  }
  rule(:text) { text_char.repeat(1) }

  rule(:element)  { text.as(:text)| ref | url | escaped_char }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end)}

  root(:elements)
end

demo_parser = DemoParser.new
result = demo_parser.parse(" ccc[http://xx.com/image.png    200 300] [hello there]x \\[x\\] [1]trailing ")

pp result
result = DemoTransformer.new.apply(result)
pp result
#result.each { |thing|  puts "#{thing[:type]}  #{thing[:value]}"  }
