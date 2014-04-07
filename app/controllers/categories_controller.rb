class CategoriesController < ApplicationController
  expose(:pages) {
    pgs = Page.all.collect do |p|
      p.ld_page_in_inverse_set(params[:id], :isa) ? p : nil
    end
    pgs.delete_if{|p| p == nil}
    pgs.collect{ |p| p.decorate }
    pgs
  }

end

