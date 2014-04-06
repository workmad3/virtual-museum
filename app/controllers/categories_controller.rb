class CategoriesController < ApplicationController
  expose(:categorized_pages) { Page.find_with_category(params[:id]).collect{|p| p.decorate } }
  expose(:pages) { cats = Page.inverse_set(params[:id], :isa)
    pgs = cats.each.collect{|c| Page.find_with_category(c) }.flatten
    pgs.uniq.collect{|p| p.decorate }
  }
end

