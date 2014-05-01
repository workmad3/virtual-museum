class PageDecorator < Draper::Decorator
  delegate_all

  # contents tab

  def content_as_html(thing)
    ContentHtmlGenerator.generate_full(thing).html_safe
  end

  def categories_as_html
    if model.categories.empty?
      "No categories"
    else
      h.render partial: 'categories/category', collection: categories_as_arr, spacer_template: 'categories/trail_spacer'
    end
  end

  def categories_as_str
    categories
  end

  def categories_as_arr
    categories == '' ? [] : categories.split(',').collect{|t| t.strip}
  end

  def tags_as_html
    if model.tags.empty?
      "No tags"
    else
      h.render partial: 'tags/tag', collection: tags_as_arr, spacer_template: 'tags/tag_spacer'
    end
  end

  def tags_as_str
    tags
  end

  def tags_as_arr
    tags == '' ? [] : tags.split(',').collect{|t| t.strip}
  end

  def edit_button_as_html(signed_in, edit_url)
    signed_in ? h.link_to("Edit page", edit_url, class: "btn btn-primary") : ''
  end

  def new_comment_form_as_html(signed_in)
    if signed_in
      h.content_tag :div, class: 'comment-form' do
        h.render :partial => 'comments/comment_form'
      end
    end
  end

  def comments_as_html
    if model.comments
      h.render(partial: 'comments/comments', locals: {comments: model.comments})
    else
      'No comments so far'
    end
  end

# history tab


# last change tab

  def last_change_as_html
    previous_content = page.previous_content
    if previous_content
      (h.render 'users/user_and_time', user: page.history.last.user.name, thing: page.history.last) +
          Diffy::Diff.new(page.previous_content, page.content).to_s(:html).html_safe
    else
      'No previous edit'
    end
  end

  def page_changes_as_html
    html = ((any_diff_as_html :title) +
    (any_diff_as_html :content) +
    (any_diff_as_html :tags) +
    (any_diff_as_html :categories)).html_safe
    html == '' ? '<p>No change on last save</p>'.html_safe : html
  end

  def compare_versions(previous, current)
    Diffy::Diff.new(previous, current).to_s(:html)
  end

  def any_diff_as_html (symb)
    if symb == :title && page.previous_title != title
      ret = '<h3>Title</h3>' +
            compare_versions(page.previous_title, title)
    elsif symb == :content  && page.previous_content != content
      ret = '<h3>Content</h3>' +
            compare_versions(page.previous_content, content)
    elsif symb == :tags && page.previous_tags != tags
      ret = '<h3>Tags</h3>' +
            compare_versions(page.previous_tags, tags)
    elsif symb == :categories && page.previous_categories != categories
      ret = '<h3>Categories</h3>' +
            compare_versions(page.previous_categories, categories)
    else
      ret = ''
    end
    ret
  end

end
