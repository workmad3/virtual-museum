require 'set'

class Page < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'PageAuthorizer'

  include LinkedData

  has_many :history, class_name: "PageState", dependent: :delete_all, autosave: true
  has_many :comments, dependent: :delete_all
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

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
  validates :slug, uniqueness: true

  #---------------------------------------------------------

  def self.find_with_category(cat)
    Page.order(:title).select{ |p| p.has_category?( cat ) ? p : nil}
  end

  def self.find_with_tag(tag)
    Page.order(:title).select{ |p| p.has_tag?( tag ) }
  end

  def self.find_by_title(t)
    Page.where(title: t).first
  end

  def self.find_by_prioritisation(p)
    Page.where(moscow: p)
  end

  #---------------------------------------------------------

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def has_page_type?(t)
    page_type == t
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  #---------------------------------------------------------

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

end