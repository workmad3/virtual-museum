class RenamePagesResourceToPageResourceUse < ActiveRecord::Migration
  def change
    rename_table :pages_resources, :page_resource_uses
  end
end
