class PagesController < ApplicationController
  def new
  end
  def create
    Page.create(user_id: current_user.id, name: params[:title], content: params[:content]).save
    redirect_to '/', status: 301
  end
  def show
    @page = Page.find(params[:id])
  end
end
