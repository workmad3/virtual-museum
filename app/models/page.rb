require 'set'

class Page < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'PageAuthorizer'

  include LinkedData

  has_many :history, class_name: "PageState", dependent: :destroy, autosave: true
  has_many :comments, dependent: :destroy
  has_many :resource_usages
  has_many :resources, through: :resource_usages

  extend HistoryControl
  history_attr :content
  history_attr :user
  history_attr :categories
  history_attr :tags
  history_attr :item_number
  history_attr :location

  attr_readonly :slug

  before_validation :set_slug, on: :create

  validates :content, presence: true
  validates :title, presence: true, uniqueness: true
  validates :slug, uniqueness: true

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

  #---------------------------------------------------------

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  #---------------------------------------------------------
=begin
  def creator-
e
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
=end

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

  def set_slug
    if slug.blank?
      self.slug = title.parameterize
    end
  end

  def slug=(new_slug)
    if self[:slug].blank?
      super
    end
  end

  def to_param
    slug
  end

  #------------------------------------------------------------------

  def ensure_page_state_id_ok
    # kludge!
    self.page_state_id = PageState.last.id + 1 if self.page_state_id == nil
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
  end
end