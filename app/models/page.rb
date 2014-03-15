class Page < ActiveRecord::Base
  extend FriendlyId
  # TODO has to become original_title
  friendly_id :original_title, use: :slugged

  has_many :page_states

  def self.find_by_title(possible_title)
    #TODO make sure duplicate titles cant be created
    #TODO find out the effect of Page.all with a large table, ie large array yielded by evaluating next expr
    Page.all.each { |p| return p if p.title == possible_title }
    return nil
  end

  def original_title=(arg)
    @original_title = arg
  end

  def original_title
    @original_title
  end

  def history
    PageState.where(page: self)
  end

  def creator
    history.last.user
  end

  def editor
    self.history.length == 1 ? nil : history.first.user
  end

  def content
    history.first.content
  end

  def title
     history.first.title
  end

  def change(editing_user, args)
    PageState.create(title: args[:title], content: args[:content], user: editing_user, page: self)
  end

  def parsed_content
    parse_content(PageState.find_by_page_id(id).content)
  end



end
