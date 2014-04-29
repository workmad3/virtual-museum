class AddLockVersionToPages < ActiveRecord::Migration
  def change
        add_column :pages, :lock_version, :integer
  end
end
