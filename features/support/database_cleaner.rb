require 'cucumber/rails'

Before do
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

# mvh Daves addition to overcome the mysterious pg disconnect problem
After do
  begin
    ActiveRecord::Base.connection.disconnect!
  rescue
  end
  ActiveRecord::Base.establish_connection
end
