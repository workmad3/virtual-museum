class CategoriesController < ApplicationController
  expose(:categorized_pages) { Page.find_with_category(params[:id]).collect{|p| p.decorate } }
end

