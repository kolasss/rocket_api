# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.1'

gem 'puma', '~> 3.11'

gem 'mongoid', '~> 7.0'
gem 'redis', '~> 4.0'

gem 'sidekiq'
gem 'sidekiq-scheduler'

# gem 'bcrypt' # TODO: use for store encoded sms code in user
gem 'jwt'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
# gem 'rack-cors'

gem 'oj' # json parser
gem 'surrealist' # json serializer

gem 'dry-monads' # for operations
gem 'dry-validation' # validations

gem 'aws-sdk-s3', '~> 1.2' # aws s3 api
gem 'image_processing', '~> 1.0' # process images
gem 'shrine', '~> 2.0' # file uploader
gem 'shrine-mongoid'

# TODO: remove github source after release > 1.9.1
gem 'faker', github: 'stympy/faker' # fake data generator

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in
  # the background. Read more: https://github.com/rails/spring
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'fuubar' # rspec output formatter
  gem 'rspec-rails-swagger' # swagger docs generator
  gem 'rspec-sidekiq' # test sidekiq jobs
end
