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
    # this assigns attributes using setters that are either provided by active record or explicitly
    if resource.update_attributes(file: params['resource']['file'],
                                  description: params['resource']['description'],
                                  title: params['resource']['title'],
                                  page_id: params['resource']['page_id']
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
    params.require(:resource).permit(:file, :description, :title, :page_id)
  end
end