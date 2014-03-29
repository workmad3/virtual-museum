class Tag < ActiveRecord::Base
  has_many :tag_sets
  has_many :page_states, :through => :tag_sets
end
