class PageDecorator < Draper::Decorator
  delegate_all

  # contents tab

  def content_as_html(thing)
    ContentHtmlGenerator.generate(thing).html_safe
  end

  def tags_as_html
    if model.tags.empty?
      "No tags"
    else
      model.tags.map{|t| h.link_to(t, "/tags/#{t}")}
    end
  end

  def edit_button_as_html(signed_in, edit_url)
    signed_in ? h.link_to("Edit", edit_url, class: "btn btn-primary") : ''
  end

  def new_comment_form_as_html(signed_in)
    if signed_in
      h.content_tag :div, class: 'comment-form' do
        h.render :partial => 'layouts/comment_form'
      end
    end
  end

  def comments_as_html
    if model.comments
      h.content_tag :ul, 'no-bullets' => true do
        h.render(partial: 'pages/comment', collection: model.comments)
      end
    else
      'No comments so far'
    end
  end

# history tab

  def history_as_html
    h.render(partial: 'pages/page_state', collection: model.history.reverse)
  end

# last change tab

  def last_change_as_html
    previous_content = page.previous_content
    if previous_content
      ('<span time-and-user>'+page.created_at.to_s+' by '+page.editor.email+'</span>'+
          Diffy::Diff.new(page.previous_content, page.content).to_s(:html)).html_safe
    else
      'No previous edit'
    end
  end

end
