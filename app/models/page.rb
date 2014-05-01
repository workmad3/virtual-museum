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

  validate :title_ok?
  validate :content_ok?
  validate :page_type_ok?

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

  def title
    @title
  end

  # used when invoking diffy
  def previous_content
    history.length == 1 ? nil : history[-2].content
  end
  def previous_title
    history.length == 1 ? nil : history[-2].title
  end
  def previous_categories
    history.length == 1 ? nil : history[-2].categories
  end
  def previous_tags
    history.length == 1 ? nil : history[-2].tags
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
    desired_compressed = self.title.tr('^A-Za-z0-9', '').downcase
    title_match = false
    slug_match = false
    Page.all.each do |p|
      existing_title_compressed = p.title.tr('^A-Za-z0-9', '').downcase
      if  desired_compressed == existing_title_compressed && p.id != self.id
        title_match = p.title
      end
      existing_slug_compressed = p.slug.tr('-', '').downcase
      if  desired_compressed == existing_slug_compressed && p.id != self.id
        slug_match = p.slug
      end

    end
    if self.title == ''
      errors.add :title, "can't be blank"
    elsif title_match == self.title
      errors.add :title, "is the same as '#{title_match}', an existing page title"
    elsif title_match
      errors.add :title, "#{self.title} is too similar to #{title_match}, an existing page title"
    elsif slug_match
      errors.add :url, "for this page is the same as or too similar to an existing url ending #{slug_match}"
    end
    if title_match || slug_match
      errors.add :hint, " titles need to differ while ignoring case, punctuation and spaces"
    end
    title_match || slug_match || self.title == ''
  end

  def content_ok?
    if self.content.blank?
      errors.add :content, " can't be blank"
    end
  end

  def page_type_ok?
    page_type_count = 0
    cats = ( self.categories == '' ? [] : self.categories.split(',').collect{|t| t.strip}.delete_if{|t| t == ''})
    self.ld_page_type.each do |type_triple|
      page_type_count = page_type_count+ 1 if cats.include?(type_triple[0])
    end
    if page_type_count == 0
      errors.add :page_type, "is not specified as #{self.ld_page_types} (as one of the categories <- will deprecate)"
    end
    if page_type_count > 1
      errors.add :page_type, 'conflict: page type specified more than once (as one of the categories <- will deprecate)'
    end
    page_type_count == 1
  end
end