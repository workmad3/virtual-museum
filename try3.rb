require 'spec_helper'
class FileHierarchy
  def initialize
    @root = '/ust/home/mark/Pictures'
    @dir_stack = []
    ls(@root)                                      # ls
  end
  def ls dir
    @ptr = 0
    if dir
      @dir_contents = [ {name: 'a.png', resource: nil, dir: false}, {name: 'b.png', resource: nil, dir: false}, {name: 'dirname', resource: nil, dir: true}, {name: 'd.png', resource: nil, dir: false} ]
    else
      @dir_contents = [ {name: 'y.png', resource: nil, dir: false}, {name: 'z.png', resource: nil, dir: false} ]
    end
  end

  def next
    if at_end_of_directory?
      return come_out_of_dir
    end
    res = @dir_contents[@ptr]
    @ptr = @ptr+ 1
    if res[:dir]
      return go_into_dir
    end
    res
  end

  private
  def at_end_of_directory?
    @ptr == @dir_contents.count
  end
  def come_out_of_dir
      if @dir_stack.count == 0
        return nil
      end
      pop_dir
      self.next
  end

  def go_into_dir
    push_dir_and_get_sub_dir
    self.next
  end

  def push_dir_and_get_sub_dir
    @dir_stack.push [@dir_contents.dup, @ptr]
    ls(nil)                                          # ls
  end

  def pop_dir
    @dir_contents, @ptr = @dir_stack.pop
  end
end

describe 'File hierarchy traversal' do
  def f() @f end
  before(:each) do
    @f = FileHierarchy.new
  end

  it 'should yield next files correctly' do
    f.next.should == {:name=>"a.png", :resource=>nil, :dir=>false}
    f.next.should == {:name=>"b.png", :resource=>nil, :dir=>false}
    f.next.should == {:name=>"y.png", :resource=>nil, :dir=>false}
    f.next.should == {:name=>"z.png", :resource=>nil, :dir=>false}
    f.next.should == {:name=>"d.png", :resource=>nil, :dir=>false}
    f.next.should == nil
  end

  it 'should yield next files correctly with empty dir and empty subdir cases' do
    true.should == false
  end

  it 'should yield next unprocessed files correctly' do
    true.should == false
  end

end


