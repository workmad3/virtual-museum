class FileParser

  def self.process(file_str)
    elements = file_str.split('/')
    raise if elements == []
    raise if elements.length > 2
    puts '----------------'
    if elements.length == 1
      process_resource(elements[0])
    else
      process_directory(elements[0])
      process_resource (elements[1])
    end
  end
  def self.process_resource(r)
    p r
  end
  def self.process_directory(d)
    p d
  end
end

Dir.chdir('/home/mark/Pictures')
Dir['**/*'].delete_if{|f|File.directory? f}.sort.each{|f| FileParser.process(f)}

