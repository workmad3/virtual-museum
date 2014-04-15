class ResourcesController < ApplicationController
  expose(:resource)         { Resource.find(params[:id]) }

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
    selected_pages = params['resource']['resource_usages']
    selected_pages = [] if selected_pages == nil
    selected_pages = [selected_pages] if selected_pages.class != Array
    selected_pages = selected_pages.delete_if{|s| s == ''}
    selected_pages = selected_pages.collect{|s| Page.find_by_id(Integer(s)) }
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
    resource.destroy
    render :index
  end


  def page_params
    params.require(:resource).permit(:file, :description, :title, :resource_usages, :pages)
  end
end