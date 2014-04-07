require 'set'

class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :original_title, use: :slugged

  has_many :history, class_name: "PageState"
  has_many :comments

  validates_associated :history

  def self.find_with_tag(tag)
    Page.all.collect{ |p| p.has_tag?( tag ) ? p : nil}.compact
  end

  def self.find_with_category(cat)
    Page.all.collect{ |p| p.has_category?( cat ) ? p : nil}.compact
  end

  def self.page_type_ld
    [ ['CollectionItem', :isa, 'Page Type'],
      ['Person', :isa, 'Page Type'],
      ['Resource', :isa, 'Page Type']]
  end

  def self.linked_data
    [ ['Computer', :isa, 'ROOT'],
      ['MU5', :isa, 'Computer'],
      ['Atlas', :isa, 'Computer'],
      ['MU6G', :isa, 'Computer'],
      ['The baby', :isa, 'Computer'],
      ['Manchester Mark 1', :isa, 'Computer'],
      ['Hardware', :is_part_of, 'Computer'],
      ['Software', :is_part_of, 'Computer'],
      ['Memory', :is_part_of, 'Hardware'],
      ['Disc Drive', :is_part_of, 'Hardware'],
      ['CPU', :is_part_of, 'Hardware'],
      ['Zorg', :isa, 'Atlas'],
      ['Zorb', :isa, 'Atlas'],
      ['Zort', :isa, 'MU6G'] ]
  end

  def self.all_included_pages(cat, relationship)
    linked_data.find_all{|t| t[1] == relationship && t[1] == cat }

  end

  def self.trail(cat, relation)
    arr = [cat]
    triple = :start_the_loop
    while triple
      triple = linked_data.find{|t| t[0]==arr.last &&  t[1] == relation}
      arr << triple[2] if triple
    end
    arr.reverse
  end

  def self.inverse_set(cat_in, rel)
    cats = linked_data.find_all{|t| t[1] == rel && t[2] == cat_in}
    res = cats.collect{|t| t[0]}
    p res
    #return nil if res == [] || res == nil
    #TODO sort put uniq - remove it and see what happens
    ret = [cat_in].concat(res.concat(res.each.collect{|c| inverse_set(c, rel)}.flatten.reject{|c| c == nil})).uniq
  end

  def creator
    history.first.user
  end

  def creator=(c)
    if history.last.try(:new_record?)
      history.last.user = c
    else
      history.new(user: c)
    end
  end

  def tags
    history.last.try(:tags)
  end

  def tags=(t)
    if history.last.try(:new_record?)
      history.last.tags = t
    else
      history.new(tags: t)
    end
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  def categories
    history.last.try(:categories)
  end

  def categories=(c)
    if history.last.try(:new_record?)
      history.last.categories = c
    else
      history.new(categories: c)
    end
  end

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def trail_for_cat(c)
    history.last.try(:trail_for_cat, c)
  end

  def editor
    self.history.length == 1 ? nil : history.last.user
  end

  def content
    history.last.try(:content)
  end

  def content=(new_content)
    if history.last.try(:new_record?)
      history.last.content = new_content
    else
      history.new(content: content)
    end
  end

  def previous_content
    history.length == 1 ? nil : history[-2].content
  end

  def title
    history.last.try(:title)
  end

  def title=(new_title)
    self.original_title ||= new_title
    if history.last.try(:new_record?)
      history.last.title = new_title
    else
      history.new(title: new_title)
    end
  end

  def original_title=(new_title)
    super
    self.title = new_title
  end

  def change(editing_user, args)
    PageState.create(title: args[:title], content: args[:content], user: editing_user, page: self)
  end

  private

end
