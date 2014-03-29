class TagSet < ActiveRecord::Base
  belongs_to :page_state
  belongs_to :tag
end
