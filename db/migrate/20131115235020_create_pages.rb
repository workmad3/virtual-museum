class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :content
      t.belongs_to :user

      t.timestamps
    end
  end
end
