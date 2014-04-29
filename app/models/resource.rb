class Resource < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'ResourceAuthorizer'

  has_many :resource_usages
  has_many :pages, through: :resource_usages

  belongs_to :user

  validates :title,   presence: {allow_blank: false }
  validate :source_ok?

  def source
    url || file
  end

  def source_ok?
    ret = (url && !file) || (!url && file)
    errors.add :either, ' one of file or URL should be set as the resource source' unless ret
    ret
  end
end
