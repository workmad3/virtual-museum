class CreatePreviousPages < ActiveRecord::Migration
  def change
    create_table :previous_pages do |t|
      t.text :title
      t.text :content
      t.belongs_to :user
      t.belongs_to :page

      t.timestamps
    end
  end
end
