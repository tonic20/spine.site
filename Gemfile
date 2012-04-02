source 'http://rubygems.org'

# Bundle edge Rails instead:
gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', :git => 'git://github.com/rails/coffee-rails.git'
  gem 'uglifier'
  gem 'stylus'
end

gem 'jquery-rails'
gem 'nestful', :git => 'git://github.com/maccman/nestful.git'
gem 'omniauth'
gem 'rdiscount'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development do
  gem 'sqlite3'
  gem "capistrano"
  gem "capistrano-ext"
  # gem "ruby-debug19", :require => "ruby-debug"
end

group :production do
  gem 'pg'
  gem "unicorn"
end