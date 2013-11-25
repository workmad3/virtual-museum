class Page < ActiveRecord::Base
  extend FriendlyId
  # TODO has to become original_title
  friendly_id :title, use: :slugged

  belongs_to :user
  validates :user_id, presence: true

  has_many :previous_pages

  def history
    ['Sample page content']
  end
end
