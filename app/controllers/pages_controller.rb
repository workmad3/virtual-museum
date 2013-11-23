class PagesController < ApplicationController
  def new
  end
  def create
    Page.create(user_id: current_user.id, title: params[:title], content: params[:content]).save
    redirect_to '/', status: 301
  end
  def show
    current_slug = request.path_info.sub(/.*\//,'')
    @page = Page.find_by slug: current_slug  end
end
