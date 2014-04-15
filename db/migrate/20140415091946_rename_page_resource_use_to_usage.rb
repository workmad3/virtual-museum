class RenamePageResourceUseToUsage < ActiveRecord::Migration
  def change
    rename_table :page_resource_uses, :resource_usages

  end
end
