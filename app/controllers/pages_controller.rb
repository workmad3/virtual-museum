class PagesController < ApplicationController
  def new
    @new_title=params[:title]
  end

  def create

    p = Page.create(original_title: params[:title])
    PageState.create(page_id: p.id,
                             user_id: current_user.id, title: params[:title], content: params[:content])
    redirect_to '/pages/' + p.slug, status: 301
  end

  def show
    current_slug = request.path_info.sub(/.*\//, '')
    @page = Page.find_by slug: current_slug
    @edit_url = '/pages/'+current_slug+'/edit'
  end

  def edit
    current_slug = $1 if request.path_info =~ /.*\/(.*)\/.*/
    @page = Page.find_by slug: current_slug
    @update_url= '/pages/'+current_slug
  end

  def update
    current_slug = request.path_info.sub(/.*\//, '')
    page = Page.find_by slug: current_slug
    page.change(current_user, params)   # TODO change to Page#change to turn on page history
    redirect_to '/pages/'+current_slug, status: 301
  end
end
