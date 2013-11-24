class PagesController < ApplicationController
  def new
  end

  def create
    Page.create(user_id: current_user.id, title: params[:title], content: params[:content]).save
    redirect_to '/', status: 301
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
    page.update(title: params[:title], content: params[:content])
    redirect_to '/pages/'+current_slug, status: 301
  end
end
