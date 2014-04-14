class AddColsToResource < ActiveRecord::Migration
  def change
    # changes to Resource table
    remove_reference :resources, :page
    add_reference :resources, :pages_resources
    add_column :resources, :copyright_holder, :string
    add_column :resources, :licence, :string
    add_column :resources, :source, :string
    add_column :resources, :url, :string

    #changes to Page table
    add_reference :pages, :pages_resources

    #join table for has_many through
    create_table :pages_resources do |t|
      t.belongs_to :page
      t.belongs_to :resource
      t.timestamps
    end

    # maybe later
    # add_index :pages_resources, :page, name: :index_pages_on_pages_resources
    # add_index :pages_resources, :resource, name: :index_resources_on_pages_resources
    
  end
end
