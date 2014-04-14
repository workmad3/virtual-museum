class AddToPageState < ActiveRecord::Migration
  def change
    add_column :page_states, :item_number, :string
    add_column :page_states, :location, :string
  end
end
