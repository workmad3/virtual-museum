class RemoveAndAddPageTitleColsInPages < ActiveRecord::Migration
  def change
    remove_column :pages, :original_title
    add_column :pages, :title, :string
  end
end
