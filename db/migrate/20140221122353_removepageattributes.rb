class Removepageattributes < ActiveRecord::Migration
  def change
    remove_column :pages, :title
    remove_column :pages, :content
    remove_column :pages, :user_id
  end
end
