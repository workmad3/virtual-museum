class AddUserToResource < ActiveRecord::Migration
  def change
    add_reference :resources, :user
  end
end
