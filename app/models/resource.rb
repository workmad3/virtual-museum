class Resource < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'ResourceAuthorizer'

  has_many :resource_usages
  has_many :pages, through: :resource_usages

  belongs_to :user

  validates :title,   presence: {allow_blank: false }
end
