#require 'spec_helper'
class FileHierarchy
  def initialize
    @root = '/home/mark/Pictures'
    @dir_stack = []
    @files = Dir.entries(@root)
    @ptr = 0
  end


  def next
    if at_end_of_dir?
      return come_out_of_dir
    end
    file_name = @files[@ptr]
    @ptr = @ptr + 1
    self.next if !! (/^\./ =~ file_name)
    if File.directory?(@root+file_name)
      return go_into_dir
    end
    file_name
  end

  private
  def at_end_of_dir?
    @ptr == @files.length
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
    @dir_stack.push [@files.dup, @ptr]
    @dir_contents = Dir.entries("./jap")
    @ptr = 0
  end

  def pop_dir
    @files, @ptr = @dir_stack.pop
  end
end

f = FileHierarchy.new
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next
p f.next

=begin
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
=end


