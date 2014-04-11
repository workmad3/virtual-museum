Dir.chdir('/home/mark/Pictures'); Dir['**/*'].delete_if{|f|File.directory? f}.sort.each{|p| process p}

def process
  def intialize
  end


end