class AddBelongsToToResource < ActiveRecord::Migration
  def change
    add_reference :resources, :page, index: true
  end
end
