class ContentHtmlGenerator
  def self.generate_full(page)
    new_markdown = page.content.gsub(/\[([^\]]*)\]/) { LinkInterpreter.new($1).process }

    markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(render_options = {}),
                                                    extensions = {})
    markdown_renderer.render new_markdown

  end

  def self.generate_part(page)
    new_markdown = page.content.gsub(/\[([^\]]*)\]/) do
      li = LinkInterpreter.new($1)
      li.process unless li.image_url?
    end

    markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(render_options = {}),
                                                extensions = {})
    markdown_renderer.render new_markdown

  end

  def self.page_image(page)
    image = nil
    page.content.gsub(/\[([^\]]*)\]/) do
      li = LinkInterpreter.new($1)
      image = li.url if ! image && li.image_url?
    end
    image = page.resources.first.source if !image && page.resources.first
    image
  end
end