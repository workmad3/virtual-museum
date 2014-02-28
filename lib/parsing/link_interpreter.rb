require 'uri'
require 'pp'

class LinkInterpreter

  def initialize text
    @text = text.strip
    @first, @rest = @text.split(/ /, 2)
    @rest.strip! if @rest
  end

  def url?
    @uri = URI.parse(@first)
    valid_scheme? && valid_host?
  rescue URI::BadURIError, URI::InvalidURIError
    false
  end

  def valid_scheme?
    %w( http https ).include?(@uri.scheme)
  end

  def valid_host?
    !(@uri.host.nil? || @uri.host.include?(".."))
  end

  def url_suffix?
    url? && ((@first =~ /\/\/[^\/]+\/[^\/]+/) != nil)
  end

  def image_url?
    url_suffix? && ((@first =~ /\.png$/) || (@first =~ /\.jpg$/))
  end

  def domain
    return nil if url? == false
    d = @first.gsub(/https?\:\/\//, '')
    d.gsub!(/\/.*/, '')
    d
  end

  def is_domain? domain_to_match
    domain.match(domain_to_match) != nil
  end

  #TODO refine checking of these URLs to see that they look good for vids

  def is_youtube_url?
    is_domain? 'youtube.com'
  end

  def is_vimeo_url?
    is_domain? 'vimeo.com'
  end

  def process_page_title
    pg = Page.find_by_title @text
    if pg != [] #TODO make find_by_title mroe friendly if page not found
      "<a href='/pages/#{pg.slug}' data-page>#{@text}</a>"
    else
      "<a href='/pages/new?page_title=#{@text}' data-new-page>#{@text}</a>"
    end
  end

  def process_url_without_text
    "<a href='#{@text}' external-link>#{@text}</a>"
  end

  def process_url_with_text
    "<a href='#{@first}' external-link>#{@rest}</a>"
  end

#TODO untested
  def process_url
    @rest == '' ? process_url_without_text : process_url_with_text
  end

  def process_image_url_without_width
    "<div><img href='#{@text}'></div>"
  end

  def process_image_url_with_width
    "<div><img href='#{@first}' style='width: #{@rest}px;'></div>"
  end

#TODO untested
  def process_image_url
    @rest == '' ? process_image_url_without_width : process_image_url_with_width
  end

#TODO untested
  def process_bracket_contents
    return process_page_title if !url?
    return process_image_url if image_url?
    return 'youtube' if is_youtube_url?
    return 'vimeo' if is_vimeo_url?
    return process_image_url if image_url?
  end


end




