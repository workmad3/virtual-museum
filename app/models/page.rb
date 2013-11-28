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

  def creator
    history == [] ? user : history.last.user
  end

  def editor
    self.history == [] ? nil : user
  end

  def change_content args
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user =  args[:user]
    self.content = args[:content]
    save
  end

  def change_title args
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user =  args[:user]
    self.title = args[:title] if args[:title]
    save
  end

  def change user, args
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user =  args[:user]
    self.title = args[:title] if args[:title]
    self.content = args[:content] if args[:content]
  end


end
