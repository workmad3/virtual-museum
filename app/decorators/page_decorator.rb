class PageDecorator < Draper::Decorator
  delegate_all

  def tab_nav
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

  def content_tab(signed_in,e_url)
    '<div id="content_tab" class="tab-pane active" >'+
        contents_to_html(model)+
        edit_button_if(signed_in,e_url)+'
    </div>'

  end

  def history_tab
    h.content_tag :div, id: "history_tab", class: "tab-pane" do
      h.content_tag :ul, "no-bullets" => true do
        show_history
      end
    end
=begin
    '<div id="history_tab" class="tab-pane" >
        <ul no-bullets>'+
          show_history+
        '</ul>
    </div>'
=end
  end

  def last_change_tab
    '<div id="last_change_tab" class="tab-pane" >
        <ul no-bullets>'+
          show_last_change+
        '</ul>
    </div>'
  end

  private

  def edit_button_if(signed_in,e_url)
    signed_in ? h.link_to("Edit", e_url, class: "btn btn-primary") : ''
  end

  def show_history
    h.render(partial: 'pages/history', collection: model.history, locals: {decorator: self})
=begin
    x = model.history.reverse.collect do |ps|
      h.content_tag :li do
        h.capture do
          h.concat h.content_tag(:span, "#{ps.created_at.to_s}  by #{ps.user.email}", 'time-and-user' => true)
          h.concat h.tag(:br)
        end
        h.content_tag
      end
             '<li>
                <span time-and-user>'+ps.created_at.to_s+' by '+User.find(ps.user_id).email+'</span>
                <br/>
                <span bold>'+ps.title+'</span>
                <br/>'+
                contents_to_html(ps)+'
                <hr/>
             </li>'

    end

    x.join('')
=end
  end

  def show_last_change
    previous_content = page.previous_content
    if previous_content
      '<span time-and-user>'+page.created_at.to_s+' by '+page.editor.email+'</span>'+
      Diffy::Diff.new(page.previous_content, page.content).to_s(:html)
    else
      'No previous edit'
    end
  end

  def contents_to_html(thing)
    ContentHtmlGenerator.generate(thing).html_safe
  end

end
