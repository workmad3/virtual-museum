class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  validates :content, presence: true
  # validates :commenter, presence: true
  #TODO add error feedback if either of the two above are true
end
