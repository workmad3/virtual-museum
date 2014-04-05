class PagesController < ApplicationController
  expose(:page)         { Page.friendly.find(params[:id]).decorate }

  def new
    #TODO only if logged in, redirect to login
    self.page = Page.new.decorate
  end

  def create
    self.page = Page.new(page_params.merge(creator: current_user))
    if page.save
      redirect_to page_url(page), status: 301
    else
      self.page = page.decorate
      render :new
    end
  end

  def show
  end


  def edit
  end

  def update
    # this assigns attributes using setters that are either provided by active record or explicitly
    if page.update_attributes(page_params.merge(creator: current_user))
      redirect_to page_url(page), status: 301
    else
      render :edit
    end
  end

  def page_params
    params.require(:page).permit(:title, :content, :tags)
  end
end
