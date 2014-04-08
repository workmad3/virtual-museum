class ClassToAddMethodsTo

  def attr_with_special_handling(args)
    args.each do |base_method_name, proc_to_apply_in_the_setter|
      # the GETTER doesn't do anything special, the intent is that the Proc becomes more complex
      self.class.send :define_method, "#{base_method_name}", Proc.new{instance_variable_get("@#{base_method_name}") }
      # the SETTER has a more complex Proc, that
      # applies the Proc supplied in the call to attr_my_acessor and then saves in the instance var
      self.class.send :define_method, "#{base_method_name}=", Proc.new { |rhs_of_equals|
        instance_variable_set("@#{base_method_name}", proc_to_apply_in_the_setter.call(rhs_of_equals))
      }
    end
  end


  def initialize
    #Q1: t would be nice to move the next send out of a method and be able to put it in a class body like attr_*
    #Q2: and it would be nice not to have to mention labda in the line too
    attr_with_special_handling x: lambda {|val| val+300;}, y: lambda {|val| val.downcase;}
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

obj = ClassToAddMethodsTo.new

puts 'after initialisation our values for x and y are "hi" "Si"'
obj.print

puts 'asking to set o.x to 3 results in it being set to 303'
obj.x = 3
obj.print

puts 'asking to set o.y to "Mark" results in it being set to "mark"'
obj.print
