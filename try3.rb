require 'spec_helper'
class FileHierarchy
  def initialize
    @root = '/ust/home/mark/Pictures'
    @dir_stack = []
    ls(@root)
  end
  def dir_contents() @dir_contents end
  def ls dir
    @ptr = 0
    if dir
      @dir_contents = [ {name: 'a.png', resource: nil, dir: false}, {name: 'b.png', resource: nil, dir: false}, {name: 'dirname', resource: nil, dir: true}, {name: 'd.png', resource: nil, dir: false} ]
    else
      @dir_contents = [ {name: 'y.png', resource: nil, dir: false}, {name: 'z.png', resource: nil, dir: false} ]
    end
  end

  def next
    if @ptr == @dir_contents.count
      if @dir_stack.count == 0
        return nil
      else
        @dir_contents, @ptr = @dir_stack.pop
        puts "POPPED @dir_contents #{@dir_contents} @ptr #{@ptr}"
        return self.next
      end
    end
    res = @dir_contents[@ptr]
    @ptr = @ptr+ 1
    puts " res is #{res} @ptr is #{@ptr}"
    if res[:dir]
      @dir_stack.push [@dir_contents.dup, @ptr]
      ls(nil)
      return self.next
    end
    res
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

  it 'should yield next unprocessed files correctly' do
    true.should == false
  end

end


