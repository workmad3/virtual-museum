class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :content
      t.belongs_to :page, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
