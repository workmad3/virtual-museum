require 'set'

class Page < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'PageAuthorizer'

  include LinkedData

  has_many :history, class_name: "PageState", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :resource_usages
  has_many :resources, through: :resource_usages

  extend HistoryControl
  history_attr :content
  history_attr :categories
  history_attr :tags
  history_attr :item_number
  history_attr :location

  #validate :title_ok?
  validate :content_ok?

  #---------------------------------------------------------

  def self.find_with_category(cat)
    Page.all.collect{ |p| p.has_category?( cat ) ? p : nil}.compact
  end

  def self.find_with_tag(tag)
    Page.all.collect{ |p| p.has_tag?( tag ) ? p : nil}.compact
  end

  def self.find_by_title(t)
    Page.all.collect{ |p| p.title == t ? p : nil}.compact.first
  end

  def self.find_by_slug(t)
    Page.find_by(slug: t)
    # returns nil if not found
  end

  #---------------------------------------------------------

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  #---------------------------------------------------------

  def creator
    history.last.try(:creator)
  end

  def creator=(c)
    if history.last.try(:new_record?)
      history.last.user = c
    else
      history.new(user: c)
    end
  end

  def title_from_history
    history.last.try(:title)
  end

  def title=(new_title)
    self['title'] = new_title
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

  #------------------------------------------------------------------

  def self.create_slug(title)
    title.parameterize
  end

  def to_param
    slug
  end

  #------------------------------------------------------------------

  def title_ok?
    new_title_chars = self.title.tr('^A-Za-z0-9', '').downcase
    match = false
    Page.all.each do |p|
      existing_title_chars = p.title.tr('^A-Za-z0-9', '').downcase
      if  new_title_chars == existing_title_chars && p.id != self.id
        match = existing_title_chars
      end
    end
    if match == self.title
      errors.add :title, "is the same as '#{match}', an existing page title"
    elsif match
      errors.add :title, "#{self.title} is too similar to #{match}, an existing page title"
      errors.add :titles, "need to differ while ignoring letter-case, spaces and punctuation"
    end
    match
  end

  def content_ok?
    if self.content.blank?
      errors.add :content, " can't be blank"
    end
  end

end