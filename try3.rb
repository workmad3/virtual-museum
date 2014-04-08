class X
  attr_accessor :x, :y
  [[:x=, '@x'], [:y=, '@y']].each do |name, instance_var|
    define_method("name"){|v| instance_variable_set(instance_var, v)}
  end
  def initialize
    @x='hi'
    @y='si'
  end
  def print
    puts "#{@x} #{@y}"
  end
end

x=X.new
x.x = 3
x.y = 4
x.print


