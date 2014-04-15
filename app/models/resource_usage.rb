class ResourceUsage < ActiveRecord::Base
  belongs_to :page
  belongs_to :resource
end
