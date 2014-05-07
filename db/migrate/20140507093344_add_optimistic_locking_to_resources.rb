class AddOptimisticLockingToResources < ActiveRecord::Migration
  def change
    add_column :resources, :lock_version, :integer
  end
end
