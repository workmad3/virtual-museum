class Content < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content
      t.page
      t.user :creator
      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end

class Page < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.integer :publisher_id
      t.string :publisher_type
      t.boolean :single_issue

      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end

rails generate model PreviousPage name: string content : text creator: user