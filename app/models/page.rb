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

  def change_content args # TODO ? SIMPLIFY ARGS
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user = args[:user]
    self.content = args[:content]
    save
  end

  def change_title args # TODO ? SIMPLIFY ARGS
    PreviousPage.create(title: title, content: content, user: user, page: self)
    self.user = args[:user]
    self.title = args[:title] if args[:title]
    save
  end

  def change editing_user, args
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
    ref = str[first.length..(str.length-last.length)]
    return [first, ref, last]
  end

  def parse_content str
    split_arr = split_string str
    split_arr.delete ''
    split_arr.each { |s| s.tokenise}
  end

=begin
    return [{link: $1}] if str =~ /^\[([^\[\]]*)\]$/
    z = ['not set yet']
    first_result = str.split /\[/, 2
    return [{:text => str}] unless first_result[1]

    z = [{text: first_result[0]},
         {link: ($1 if first_result[1] =~ /^([^\]]*)/)},
         {text: ($1 if first_result[1] =~ /^[^\]]*\](.*)/)}
    ]

    z.delete text: ''
    tail_str = z[z.count-1][:text]
    tail_str = '[' +tail_str if tail_str =~ /^[^\[]*\]$/

    if tail_str
      res = parse_content tail_str
      if res.count == 1
        return z
      else
        z.delete_at(z.count-1)
        return z.concat(res)
      end
    end
    z

  end
=end


end
