class AddMoscowToPages < ActiveRecord::Migration
  def change
    add_column :pages, :moscow, :string, default: "Not set yet"
  end
end
