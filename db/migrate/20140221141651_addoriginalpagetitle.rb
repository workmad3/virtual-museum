class Addoriginalpagetitle < ActiveRecord::Migration
  def change
    add_column :pages, :original_title, :string
  end
end
