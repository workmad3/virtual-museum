require 'uri'
require 'pp'

class LinkInterpreter

  def initialize text
    @text = text.strip
    @first, @rest = text.split(/ /, 2)
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
    url_suffix? && ((@first =~ /\.png/) || (@first =~ /\.jpg/))
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

  def process_bracket_contents
  end

  def process_page_title  page_title
    pg = Page.find_by_title page_title
    if pg
      "<a href='/pages/#{pg.slug}' style='color: #0000FF'>#{page_title}</a>"
    else
      "<a href='/pages/#{pg.slug}/new' style='color: #0000FF'>#{page_title}</a>"
    end
  end


end




