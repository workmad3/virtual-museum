=begin
begin
  require 'database_cleaner'
  require 'database_cleaner/cucumber'

  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Before do
  DatabaseCleaner.clean
end
=end

require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

Before do
  DatabaseCleaner.clean
end
