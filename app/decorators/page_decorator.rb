class PageDecorator < Draper::Decorator
  delegate_all

  def tab_nav
    h.content_tag :ul, id: 'tabs', class: 'nav nav-tabs', 'data-tabs'.to_sym => '"tabs" 'do
      ( h.content_tag :li, class: 'active' do
          h.content_tag :a, href: '#content_tab', 'data-toggle'.to_sym => 'tab' do 'Page' end
      end ) +
      ( h.content_tag :li do
          h.content_tag :a, href: '#history_tab', 'data-toggle'.to_sym => 'tab' do 'History' end
      end ) +
      ( h.content_tag :li do
          h.content_tag :a, href: '#last_change_tab', 'data-toggle'.to_sym => 'tab' do 'Last Change' end
      end )
    end
  end


=begin
    '<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
      <li class="active">
        <a href="#content_tab" data-toggle="tab">Page</a>
      </li>
      <li>
        <a href="#history_tab" data-toggle="tab">History</a>
      </li>
      <li>
        <a href="#last_change_tab" data-toggle="tab">Last change</a>
      </li>
    </ul>'
  end
=end

  def content_tab(signed_in, e_url)
    h.content_tag :div, id: 'content_tab', class: 'tab-pane active' do
      contents_to_html(model) +
      tags_to_html +
      edit_button_if(signed_in, e_url)
    end
  end

  def history_tab
    h.content_tag :div, id: 'history_tab', class: 'tab-pane' do
      h.content_tag :ul, 'no-bullets' => true do
        show_page_state
      end
    end
  end

  def last_change_tab
    h.content_tag :div, id: 'last_change_tab', class: 'tab-pane' do
      h.content_tag :ul, 'no-bullets' => true do
        show_last_change
      end
    end
  end

  def tags_to_html
    if model.tags
      tags = model.tags
      tarr = tags.split(',').collect{|t| t.strip!; " <a href='/tags/#{t}'>#{t}</a>"}
      out = 'Tags: '+tarr.join(', ')+'<br/><br/>'
      out.html_safe
    else
      'No tags<br/><br/>'.html_safe
    end
  end

  private

  def edit_button_if(signed_in, edit_url)
    signed_in ? h.link_to("Edit", edit_url, class: "btn btn-primary") : ''
  end

  def show_page_state
    h.render(partial: 'pages/page_state', collection: model.history.reverse)
  end

  def show_last_change
    previous_content = page.previous_content
    if previous_content
      ('<span time-and-user>'+page.created_at.to_s+' by '+page.editor.email+'</span>'+
          Diffy::Diff.new(page.previous_content, page.content).to_s(:html)).html_safe
    else
      'No previous edit'
    end
  end

  def contents_to_html(thing)
    ContentHtmlGenerator.generate(thing).html_safe
  end



end
