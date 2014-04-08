class X
  #attr_accessor :x, :y

  [
    ['x', Proc.new{|val| val+100;}],
    ['y', Proc.new{|val| val.downcase;}]
  ].each do |name, proc|
    define_method("#{name}="){|v| instance_variable_set("@#{name}", proc.call(v))}
  end

  def initialize
    @x='hi'
    @y='Si'
  end
  def print
    puts "#{@x} #{@y}"
  end
end

x=X.new
x.x = 3
x.y = '-----'
x.print


