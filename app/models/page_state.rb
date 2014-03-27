class PageState < ActiveRecord::Base

  default_scope -> { order('created_at ASC') }

  belongs_to :page

  before_validation(:on => :create) do
    @attributes['title'] = cleanit (@attributes['title'])
    @attributes['content'] = cleanit (@attributes['content'])
  end

  validates :page_id, presence: true

  belongs_to :user
  validates :user_id, presence: true

  private
  def cleanit(str)
=begin
    semi_cleaned_str = ( str.gsub(/\>/,'&gt;') || str )
    semi_cleaned_str.gsub(/\</,'&lt;') || semi_cleaned_str
=end
str
  end
end
