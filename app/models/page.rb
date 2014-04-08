require 'set'

class Page < ActiveRecord::Base

  include LinkedData
  extend FriendlyId
  friendly_id :original_title, use: :slugged
  extend HistoryControl

  has_many :history, class_name: "PageState"
  has_many :comments

  history_attr :content
  history_attr :categories
  history_attr :tags

  validates_associated :history

  #---------------------------------------------------------

  def self.find_with_category(cat)
    Page.all.collect{ |p| p.has_category?( cat ) ? p : nil}.compact
  end

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def self.find_with_tag(tag)
    Page.all.collect{ |p| p.has_tag?( tag ) ? p : nil}.compact
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  #---------------------------------------------------------

  def creator
    history.last.try(:creator)
  end

  def title
    history.last.try(:title)
  end

  def creator=(c)
    if history.last.try(:new_record?)
      history.last.user = c
    else
      history.new(user: c)
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

  # Page#change now only used in tests, refactor to not exist
  def change(editing_user, args)
    PageState.create(title: args[:title], content: args[:content], user: editing_user, page: self)
  end

  def editor
    self.history.length == 1 ? nil : history.last.user
  end




  # used when invoking diffy
  def previous_content
    history.length == 1 ? nil : history[-2].content
  end


end