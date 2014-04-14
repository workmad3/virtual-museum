class AddTagsToPageState < ActiveRecord::Migration
  def change
    add_column :page_states, :tags, :string
  end
end
