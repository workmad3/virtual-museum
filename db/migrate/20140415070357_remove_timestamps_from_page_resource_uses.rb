class RemoveTimestampsFromPageResourceUses < ActiveRecord::Migration
  def change
    remove_timestamps :page_resource_uses
  end
end
