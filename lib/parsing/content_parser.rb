class ContentParser < Parslet::Parser
  rule(:space) { (match('\s')).repeat(0) }
  rule(:space?) { space.maybe }

  rule(:newline) { str("\r\n").as(:newline) }
  #rule(:escaped_char) { str('\\') >> any.as(:newline) }

  rule(:open_bracket) { match('\[') }
  rule(:close_bracket) { match('\]') }

  rule(:text) { match('[a-zA-Z0-9 \:\/\. \-\_\?\=\.,:{}<>\'\"\+\-!@#\$\%^&*\(\)\~\`\|`]').repeat(1) }
  rule(:contents) { open_bracket >> text.as(:contents) >> close_bracket }

  rule(:element) { text.as(:text)| contents } # | escaped_char }

  rule(:elements) { space?.as(:start) >> element.repeat(0) >> space?.as(:end) }

  rule(:paragraphs) { elements >> (newline >> elements).repeat(0) >> newline.repeat(0) }

  root(:paragraphs)
end