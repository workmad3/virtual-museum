class AddCatgoriesToPageState < ActiveRecord::Migration
  def change
    add_column :page_states, :categories, :string
  end
end
