class RemovePagesResourcesIdFromResources < ActiveRecord::Migration
  def change
    # this shouldnt have been there made mistakenly while learning
    remove_column :resources, :pages_resources_id
  end
end
