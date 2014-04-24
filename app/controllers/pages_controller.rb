class PagesController < ApplicationController
  expose(:page)         { Page.find_by_slug(params[:id]).decorate  }

  before_action :authenticate_user!, :except => [:index, :show]
    # delete admin authorised in #destroy

  def new
    p = Page.new(title: params[:page_title])
    self.page = p.decorate
    render :new
  end

  def create
      self.page = Page.new( page_params.merge( creator: current_user,
                                                slug: Page.create_slug( page_params['title'] ) ) )
      if page.save
        redirect_to page_url(page), status: 301
        # duplicate key value violates unique constraint "index_pages_on_title"
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

  def destroy
    authorize_action_for page
    page.destroy
    redirect_to :back
  end

  def page_params
    params.require(:page).permit(:title, :content,
                                 :tags, :categories,
                                 :item_number, :location, :creator )
  end
end
