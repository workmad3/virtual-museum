class Resource < ActiveRecord::Base
  has_many :page_resource_uses
  has_many :pages, through: :page_resources_uses
end
