class ResourcesController < ApplicationController
  expose(:resource)         { Resource.find(params[:id]) }

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def page_params
    params.require(:resource).permit(:file, :description)
  end
end