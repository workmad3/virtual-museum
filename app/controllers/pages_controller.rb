class PagesController < ApplicationController
  expose(:current_slug) { request.path_info.gsub(/.*pages\//,'').gsub(/\/.*/,'') }
  expose(:page)         { Page.find_by_slug(current_slug).decorate }
  expose(:edit_url)     { '/pages/'+current_slug+'/edit' }
  expose(:update_url)   { '/pages/'+current_slug }


  def new
  end

  def create

      p = Page.create(original_title: params[:title])
      PageState.create(page_id: p.id,
                             user_id: current_user.id, title: params[:title], content: params[:content])
    redirect_to '/pages/'+p.slug, status: 301

  end

  def show
  end

  def edit
  end

  def update
    page.change(current_user, params)
    redirect_to '/pages/'+current_slug, status: 301
  end
end
