class PageState < ActiveRecord::Base

  default_scope -> { order('created_at ASC') }

  belongs_to :page
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
    str.blank? ? [] : str.split(',').collect{|t| t.strip}.delete_if{|t| t == ''}
  end

end
