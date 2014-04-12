# usage: Organise a two level structure of dirs representing catalogue items and image resources in them

#   eg in /home/mark/Pictures
# 1
#   ones_image.png
# etc

# DirectoryParser.grab('/home/mark/Pictures')


class DirectoryParser
  def self.grab (directory)
    start_dir = Dir.pwd
    Dir.chdir(directory)
    Dir['**/*'].delete_if{|f|File.directory? (f) }.sort.each{|f| process(f) }
    Dir.chdir(start_dir)
  end

  def self.process(file_str)
    elements = file_str.split('/')
    raise if elements == []
    raise if elements.length > 2
    if elements.length == 1
      process_resource(elements[0])
    else
      process_collection_item(elements[0], elements[1])
    end
  end

  private

  def self.process_resource(r)
    puts "resource: #{r}"
  end

  def self.process_collection_item(d, r)
    puts "directory: #{d}"
    puts "resource: #{r}"
  end
end
