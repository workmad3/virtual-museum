class Changetablenametopagestate < ActiveRecord::Migration
    def change
      rename_table :previous_pages, :page_states
    end
  end