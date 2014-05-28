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
    success = true
    Page.transaction do
      if need_to_update?
        success = page.update_attributes(page_params.merge(user: current_user))
      end
    end
    if success
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
                                 :moscow,
                                 :slug,
                                 :tags,
                                 :title,
                                 :page_type
                                 )
  end

  private

  def need_to_update?
    page.title          != page_params[:title]      ||
        page.categories != page_params[:categories] ||
        page.tags       != page_params[:tags]       ||
        page.content    != page_params[:content]    ||
        page.page_type  != page_params[:page_type]  ||
        page.moscow     != page_params[:moscow]
  end

end
