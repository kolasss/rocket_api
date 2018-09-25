# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use Puma as the app server
gem 'mongoid', '~> 7.0'
gem 'puma', '~> 3.11'

# gem 'bcrypt' # TODO: use for store encoded sms code in user
gem 'jwt'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
# gem 'rack-cors'

gem 'oj' # json parser
gem 'surrealist' # json serializer

gem 'dry-monads' # for operations
gem 'dry-validation' # validations

# TODO: remove github source after release > 1.9.1
gem 'faker', github: 'stympy/faker' # fake data generator

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec-rails-swagger', require: false # swagger docs generator
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in
  # the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'fuubar' # rspec output formatter
end
