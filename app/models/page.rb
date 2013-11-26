class Page < ActiveRecord::Base
  extend FriendlyId
  # TODO has to become original_title
  friendly_id :title, use: :slugged

  belongs_to :user
  validates :user_id, presence: true

  has_many :previous_pages

  def history
    PreviousPage.where(page: self)
  end

  def new_title_and_or_content args
    PreviousPage.create(title: title, content: content, user: args[:user], page: self)
    self.title = args[:title] if args[:title]
    self.content = args[:content] if args[:content] != nil
    save
  end

end
