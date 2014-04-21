class RemovePagesResourcesIdFromPage < ActiveRecord::Migration
  def change
    # this shouldnt have been there made mistakenly while learning
    remove_column :pages, :pages_resources_id
  end
end
