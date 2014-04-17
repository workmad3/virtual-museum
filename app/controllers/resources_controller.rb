class ResourcesController < ApplicationController
  expose(:resource)         { Resource.find(params[:id]) }

  before_action :authenticate_user!, :except => [:index, :show]
  # use the above instead of Authorize's authorize_actions_for Page, except: [:index, :show]
  # because we are interested if someone is signed in or not
  # except int he case of delete when they must be signed in and an admin, see
  #     authorize_action_for p
  # in destroy

  def new
    self.resource = Resource.new
  end

  def create
    self.resource = Resource.new(file: params['resource']['file'],
                                  description: params['resource']['description'],
                                  title: params['resource']['title'],
                                  pages: params['resource']['page_ids'].split(',')
                                 )
    if resource.save
      redirect_to resource_url(resource), status: 301
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    titles_to_add = params['resource_pages']
                      .collect{|title,checked|checked=='0'?nil:title}.delete_if{|v|!v}
    selected_pages = []
    titles_to_add.each do |t|
      selected_pages << Page.find_by_title(t)
    end

    # this assigns attributes using setters that are either provided by active record or explicitly
    if resource.update_attributes(file: params['resource']['file'],
                                  description: params['resource']['description'],
                                  title: params['resource']['title'],
                                  pages: selected_pages
                                  )
      redirect_to resource_url(resource), status: 301
    else
      render :edit
    end
  end

  def destroy
    authorize_action_for resource
    resource.destroy
    render :index
  end


  def page_params
    params.require(:resource).permit(:file, :description, :title, :resource_usages, :pages)
  end
end