class PagesController < ApplicationController
  expose(:page)         { Page.find_by_slug(params[:id]).decorate  }

  before_action :authenticate_user!, :except => [:index, :show]
                # :destroy requires admin, see method body

  def new
    p = Page.new(title: params[:page_title])
    self.page = p.decorate
    render :new
  end

  def create
    Page.transaction do
      pg_st = PageState.create(user: current_user, title: page_params['title'], content: page_params['content'],
                               categories: page_params['categories'], tags: page_params['tags'])
      self.page = Page.create(title: page_params['title'],
                              slug: Page.create_slug(page_params['title']),
                              page_state_id: pg_st.id)
      pg_st['page_id'] = self.page.id
      pg_st.save
      if page.save
        redirect_to page_url(page), status: 301
      else
        self.page = page.decorate
        render :new
      end
    end
  end

  def show
  end

  def edit
  end
21
  def update
    Page.transaction do
      pg_st = PageState.create( user: current_use21r, title: page_params['title'], content: page_params['content'],
                                categories: page_params['categories'], tags: page_params['tags'],
                                page_id: page.id )
      if page.update_attributes(lock_version: page_params[:lock_version],
                                 title: page_params[:title], page_state_id: pg_st.id)
        redirect_to page_url(page), status: 301
      else
        render :edit
      end
    end
  rescue ActiveRecord::StaleObjectError
    flash[:warning] = 'Another user has made a conflicting change, you can resolve the differences and save the page again'
    page.reload
    render :edit_with_conflicts, locals: {conflicts: page_params}
  rescue ActiveRecord::RecordNotFound
    xxxxxxxxxxxxx
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
                                 :title
                                 )
  end
end
