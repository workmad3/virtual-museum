class Resource < ActiveRecord::Base
  has_many :resource_usages
  has_many :pages, through: :resource_usages
end
