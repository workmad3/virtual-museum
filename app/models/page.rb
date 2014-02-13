class Page < ActiveRecord::Base
  extend FriendlyId
  # TODO has to become original_title
  friendly_id :title, use: :slugged

  belongs_to :user
  validates :user_id, presence: true

  has_many :previous_pages

  def history
    PreviousPage.where(page: self)
  end

  def creator
    history == [] ? user : history.last.user
  end

  def editor
    self.history == [] ? nil : user
  end

  def change(editing_user, args)
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user = editing_user
    self.title = args[:title] if args[:title]
    self.content = args[:content] if args[:content]
    save
  end

  def split_string str
    first_array = str.split /\[/, 2
    return ['', str, ''] unless first_array[1]
    last_array = str.split /\]/, 2
    first = first_array[0]
    last = last_array[1]
    ref = str[first.length..(str.length-last.length-1)]
    [first, ref, last]
  end

  def tokenize str
    return {text: str} unless str =~ /\[/
    desired_title = str[1..-2]
    p = Page.find_by_title(desired_title)
    if p
      {link: {title: p.title, slug: p.slug, exists: true}}
    else
      {link: {title: desired_title, slug: 'slug-not-used', exists: false}}
    end
  end

  def parsed_content
    return parse_content(content)
  end

  def parse_content str, recurse=nil
    split_arr = split_string str
    split_arr.delete ''

    return []              if split_arr.count == 0
    return [str]           if split_arr.count == 1 if recurse
    return [tokenize(str)] if split_arr.count == 1 && recurse == nil

    last = split_arr.last
    split_arr.pop
    split_arr.concat(parse_content(last, true))

    return split_arr       if recurse
    split_arr.collect { |str| tokenize(str) }
  end

end
