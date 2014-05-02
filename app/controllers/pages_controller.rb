class PagesController < ApplicationController
  expose(:page) { Page.find_by_slug(params[:id]).decorate  }

  before_action :authenticate_user!, :except => [:index, :show]
                # :destroy requires admin, see method body

  def new
    p = Page.new(title: params[:page_title])
    self.page = p.decorate
    render :new
  end

  def create
    page = Page.new(page_params.merge(user: current_user))
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
    if page.update_attributes(page_params.merge(user: current_user))
      redirect_to page_url(page), status: 301
    else
      render :edit
    end
  rescue ActiveRecord::StaleObjectError
    flash.now[:warning] = 'Another user has made a conflicting change, you can resolve the differences and save the page again'
    page.reload
    @conflict = Page.new(page_params)
    render :edit_with_conflicts
  end



  def destroy
    authorize_action_for page
    page.destroy
    redirect_to :back
  end

  def page_params
    params.require(:page).permit(:categories,
                                 :content,
                                 :creator,
                                 :item_number,
                                 :location,
                                 :lock_version,
                                 :tags,
                                 :title,
                                 :slug
                                 )
  end
end
