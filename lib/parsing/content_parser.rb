class ContentParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(1) }
  rule(:space?) { space.maybe }

  rule(:escaped_char) { str('\\') >> any.as(:esc) }

  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }

  rule(:contents_text) { match('[a-zA-Z0-9 \:\\\/\. \-\_\?\=]').repeat(1) }
  rule(:contents) { open_bracket >> contents_text.as(:contents) >> close_bracket }


  rule(:text_char) { match('[a-zA-Z0-9 ,.;:\'\"=\(\)#-/\|\]]') }
  rule(:text) { text_char.repeat(1) }

  rule(:element) { text.as(:text)| contents | escaped_char }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end) }

  root(:elements)
end