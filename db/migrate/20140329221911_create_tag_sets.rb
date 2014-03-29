class CreateTagSets < ActiveRecord::Migration
  def change
    create_table :tag_sets do |t|
      t.belongs_to :tags
      t.belongs_to :page_state

      t.timestamps
    end
  end
end
