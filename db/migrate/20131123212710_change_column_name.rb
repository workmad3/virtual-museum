class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :pages, :name, :title
  end
end
