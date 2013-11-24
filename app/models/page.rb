class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  validates :user_id, presence: true

  def history
    ['Sample page content']
  end
end
