class CreatePage < ActiveRecord::Migration
  def change
    create_table :page do |t|
      t.string :name
      t.text :content
      t.belongs_to :user

      t.timestamps
    end
  end
end
