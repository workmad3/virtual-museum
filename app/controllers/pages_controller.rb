class PagesController < ApplicationController
  expose(:page)         { Page.friendly.find(params[:id]).decorate  }

  before_action :authenticate_user!, :except => [:index, :show]
  # use the above instead of Authorize's authorize_actions_for Page, except: [:index, :show]
  # because we are interested if someone is signed in or not
  # except int he case of delete when they must be signed in and an admin, see
  #     authorize_action_for p
  # in destroy

  def new
    p = Page.new(title: params[:page_title])
    self.page = p.decorate
    render :new
  end

  def create
      self.page = Page.new(page_params.merge(creator: current_user))
      if page.save
        redirect_to page_url(page), status: 301
      else
        self.page = page.decorate
        render :create
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
    p = Page.friendly.find(page.slug)
    authorize_action_for p
    p.destroy
    render :index
  end

  def page_params
    params.require(:page).permit(:title, :content,
                                 :tags, :categories,
                                 :item_number, :location, :creator )
  end
end
