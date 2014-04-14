class TagsController < ApplicationController
  expose(:tagged_pages) { Page.find_with_tag(params[:id]).collect{|p| p.decorate } }
end

