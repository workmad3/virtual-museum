require 'set'

class Page < ActiveRecord::Base
  include LinkedData

  extend FriendlyId
  friendly_id :original_title, use: :slugged

  has_many :history, class_name: "PageState"
  has_many :comments

  validates_associated :history

  #---------------------------------------------------------

  def self.find_with_tag(tag)
    Page.all.collect{ |p| p.has_tag?( tag ) ? p : nil}.compact
  end

  def self.find_with_category(cat)
    Page.all.collect{ |p| p.has_category?( cat ) ? p : nil}.compact
  end

  #---------------------------------------------------------

  def categories
    history.last.try(:categories)
  end

  def content
    history.last.try(:content)
  end

  def creator
    history.first.user
  end

  def tags
    history.last.try(:tags)
  end

  def title
    history.last.try(:title)
  end

  #---------------------------------------------------------

  def categories=(c)
    if history.last.try(:new_record?)
      history.last.categories = c
    else
      history.new(categories: c)
    end
  end

  def content=(new_content)
    if history.last.try(:new_record?)
      history.last.content = new_content
    else
      history.new(content: content)
    end
  end

  def creator=(c)
    if history.last.try(:new_record?)
      history.last.user = c
    else
      history.new(user: c)
    end
  end

  def tags=(t)
    if history.last.try(:new_record?)
      history.last.tags = t
    else
      history.new(tags: t)
    end
  end

  def title=(new_title)
    self.original_title ||= new_title
    if history.last.try(:new_record?)
      history.last.title = new_title
    else
      history.new(title: new_title)
    end
  end

  #------------------------------------------------------------------

  # now only used in tests, refactor to not exist
  def change(editing_user, args)
    PageState.create(title: args[:title], content: args[:content], user: editing_user, page: self)
  end

  def editor
    self.history.length == 1 ? nil : history.last.user
  end

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  def original_title=(new_title)
    super
    self.title = new_title
  end

  def previous_content
    history.length == 1 ? nil : history[-2].content
  end

  # unused?
  def trail_for_cat(c)
    history.last.try(:trail_for_cat, c)
  end

end
