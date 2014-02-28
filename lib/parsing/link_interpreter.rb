require 'uri'
require 'pp'

class LinkInterpreter

  def initialize text
    @text = text.strip
    @first, @rest = text.split(/ /, 2)
  end

  def url?
    return false if ((@first =~ /^http\:\/\//) == nil) && ((@first =~ /^https\:\/\//) == nil)
    return false if (@first =~ /\.\./) != nil
    uri = URI.parse(@first)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
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

  def process page_name
    pg = Page.find_by_title page_name
    if pg
      pg.current_slug
    else
      nil
    end
  end


end




