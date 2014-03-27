require 'parsing/link_interpreter'
class ContentHtmlGenerator
  def self.generate(page)

    new_markdown = page.content.gsub(/\[([^\]]*)\]/) { LinkInterpreter.new($1).process }

    markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(render_options = {}), extensions = {})
    markdown_renderer.render new_markdown

  end
end