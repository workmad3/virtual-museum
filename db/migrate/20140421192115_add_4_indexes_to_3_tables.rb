class Add4IndexesTo3Tables < ActiveRecord::Migration
  def change
    add_index :page_states,           :page_id, using: :btree
    add_index :pages,                 :title,         unique: true,   using: :btree
    add_index :resource_usages,       :page_id
    add_index :resource_usages,       :resource_id
  end
end
