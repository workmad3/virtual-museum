class AddPageStateToPages < ActiveRecord::Migration
  def change
    add_reference :pages, :page_state
  end
end
