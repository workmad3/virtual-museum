class PageState < ActiveRecord::Base

  default_scope -> { order('created_at DESC') }

  belongs_to :page
  validates :page_id, presence: true

  belongs_to :user
  validates :user_id, presence: true
end
