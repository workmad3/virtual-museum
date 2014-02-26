class ContentParser < Parslet::Parser

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