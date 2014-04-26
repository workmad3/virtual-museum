class ResourcesController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  expose(:resource) { resource_or_nil }

  def resource_or_nil
    id = params[:id]
    result = nil
    if id == id.gsub(/[^0-9]/, '').gsub(/^0/,'')
      result = begin
        Resource.find(id) rescue nil
      end
    end
    result
  end

  def new
    self.resource = Resource.new
  end

  def create
    selected_pages = get_titles_from_params
    self.resource = Resource.new( file: params['resource']['file'],
                                  url: params['resource']['url'],
                                  description: params['resource']['description'],
                                  title: params['resource']['title'],
                                  pages: selected_pages,
                                  user: current_user
                                 )
    if resource.save
      redirect_to resource_url(resource), status: 301
    else
      render :new
    end
  end

  def show
    unless resource
      flash[:warning] = ["Resource #{params[:id]} does not exist"]
      redirect_to resources_path
    end
  end

  def edit
    unless resource
      flash[:warning] = ["Resource #{params[:id]} does not exist"]
      redirect_to resources_path
    end
  end

  def update
    selected_pages = get_titles_from_params

    update_params = { description: params['resource']['description'],
                      title: params['resource']['title'],
                      pages: selected_pages }

    # update_attributes this assigns attributes using setters that are either provided by active record or explicitly
    if resource.update_attributes(update_params)
      redirect_to resource_url(resource), status: 301
    else
      render :edit
    end
  end

  def destroy
    authorize_action_for resource # user must be an admin
    resource.destroy
    redirect_to :back
  end


  def page_params
    params.require(:resource).permit(:file, :description, :title, :resource_usages, :pages)
  end

  private

  def get_titles_from_params
    titles_to_add = params['resource_pages'].collect{ |title, checked| checked=='0' ? nil : title }.delete_if { |v| !v }
    selected_pages = []
    titles_to_add.each do |t|
      selected_pages << Page.find_by_title(t)
    end
    selected_pages
  end
end