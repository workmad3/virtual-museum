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
    </ul>'
  end

  def content_tab(signed_in,e_url)
    '<div id="content_tab" class="tab-pane active" >'+
        contents_to_html(model)+
        edit_button_if(signed_in,e_url)+'
    </div>'

  end

  def history_tab
    '<div id="history_tab" class="tab-pane" >
        <ul no-bullets>'+
          show_history+
        '</ul>
    </div>'
  end

  private

  def edit_button_if(signed_in,e_url)
    signed_in ? h.link_to("Edit", e_url, class: "btn btn-primary") : ''
  end

  def show_history
    x = model.history.reverse.collect do |ps|
             '<li>
                <span time-and-user>'+ps.created_at.to_s+' by '+User.find(ps.user_id).email+'</span>
                <br/>
                <span bold>'+ps.title+'</span>
                <br/>'+
                contents_to_html(ps)+'
             </li>'
    end
    x.join('')
  end

  def contents_to_html(thing)
    ContentHtmlGenerator.generate(thing)
  end

end
