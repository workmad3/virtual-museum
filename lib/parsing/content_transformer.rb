require './lib/parsing/link_interpreter'

class ContentTransformer < Parslet::Transform

  rule(:start => simple(:start)) { '<p>' }

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