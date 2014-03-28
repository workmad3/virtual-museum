class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :original_title, use: :slugged

  has_many :history, class_name: "PageState"

  validates_associated :history

  def creator
    history.first.user
  end

  def creator=(c)
    if history.last.try(:new_record?)
      history.last.user = c
    else
      history.new(user: c)
    end
  end

  def editor
    self.history.length == 1 ? nil : history.last.user
  end

  def content
    history.last.try(:content)
  end

  def content=(new_content)
    if history.last.try(:new_record?)
      history.last.content = new_content
    else
      history.new(content: content)
    end
  end

  def previous_content
    history.length == 1 ? nil : history[-2].content
  end

  def title
    history.last.try(:title)
  end

  def title=(new_title)
    self.original_title ||= new_title
    if history.last.try(:new_record?)
      history.last.title = new_title
    else
      history.new(title: new_title)
    end
  end

  def original_title=(new_title)
    super
    self.title = new_title
  end

  def change(editing_user, args)
    PageState.create(title: args[:title], content: args[:content], user: editing_user, page: self)
  end
end
