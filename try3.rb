class X
  #attr_accessor :x, :y

  def attr_my_accessor(args)
    args.each do |name, proc|
      self.class.send :define_method, "#{name}", Proc.new{instance_variable_get("@#{name}") }
      self.class.send :define_method, "#{name}=", Proc.new { |rhs_of_equals|
        instance_variable_set("@#{name}", proc.call(rhs_of_equals))
      }
    end
  end

  def initialize
    attr_my_accessor(x: lambda {|val| val+100;}, y: lambda {|val| val.downcase;})

    @x='hi'
    @y='Si'
  end
  def setit
    @y = 'Mark'
  end
  def print
    puts "#{@x} #{@y}"
  end
end

o=X.new
puts 'after initialisation'
o.print
puts 'set o.x to 3'
o.x = 30000

o.print



=begin
  [
    ['x', lambda {|val| val+100;}],
    ['y', lambda {|val| val.downcase;}]
  ].each do |name, proc|
    define_method("#{name}="){|v| instance_variable_set("@#{name}", proc.call(v)) }
    define_method("#{name}") {    instance_variable_get("@#{name}") }
  end
=end
