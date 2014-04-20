module PageHelper
  def safe_html(pg)
    #TODO remove
    xxx should never get here
  ContentHtmlGenerator.generate_full(pg).html_safe
  end
  end