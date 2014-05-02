module HistoryControl
  def history_attr(attr)
    define_method attr do
      history.last.try(attr)
    end

=begin
    define_method "#{attr}=" do |new_val|
      if history.last.try(:new_record?)
        history.last.send("#{attr}=", new_val)
      else
        history.new(attr => new_val)
      end
    end
=end
  end
end