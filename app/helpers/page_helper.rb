module PageHelper
  def safe_html(pg)
  ContentHtmlGenerator.generate(pg).html_safe
  end
  end