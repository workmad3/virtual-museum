class ContentTransformer < Parslet::Transform
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