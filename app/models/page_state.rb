class PageState < ActiveRecord::Base

  default_scope -> { order('created_at ASC') }

  belongs_to :page

=begin
  before_validation(:on => :create) do
    TODO dave changed here - think about
    self.title = cleanit(title)
    attributes['content'] = cleanit(attributes['content'])
  end
=end

  validate :uniqueish_title
  validates :title,   presence: {allow_blank: false }
  validates :content, presence: {allow_blank: false }
  #TODO is this meaningless?
  validates :tags,    presence: {allow_blank: true }

  belongs_to :user

  def categories=(new_categories)
    begin
      self['categories'] = clean(new_categories)
    rescue
      self['categories'] = ''
    end
  end

  def tags=(new_tags)
    begin
      self['tags'] =  clean(new_tags)
    rescue
      self['tags'] = ''
    end
  end

  def categories_as_array
    as_array(categories)
  end

  def tags_as_array
    as_array(tags)
  end

  def has_category?(cat)
    categories ? categories.include?(cat) : false
  end

  def has_tag?(tag)
    tags ? tags.include?(tag) : false
  end

  private

  def clean(str)
    str.split(',').map(&:strip).uniq.delete_if{|t| t == ''}.sort{|a,b|a.downcase<=>b.downcase}.join(', ')
  end

  def as_array(str)
    str == '' ? [] : str.split(',').collect{|t| t.strip}.delete_if{|t| t == ''}
  end

  def cleanit(str)
    #TODO improve sanitisation
    #semi_cleaned_str = ( str.gsub(/>/,'.>') || str )
    #semi_cleaned_str.gsub(/</,'&lt;') || semi_cleaned_str
  end

  #TODO change needed here if want to allow re-use of old titles that aren't currently in use
  def uniqueish_title
    if PageState.where(title: self.title).where.not(page_id: self.page_id).exists?
      errors.add :title, "is in use"
    end
  end
end
