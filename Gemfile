# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# default
gem 'rails',      '~> 6.0.2', '>= 6.0.2.1'
gem 'pg',         '>= 0.18', '< 2.0'
gem 'puma',       '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker',  '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder',   '~> 2.7'
gem 'bootsnap',   '>= 1.4.2', require: false

# authenticate
gem 'devise'

# other
gem 'rspec-rails', '4.0.0.beta3'
gem 'factory_bot_rails'
gem 'faker'
gem 'enumerize'
gem 'active_model_serializers', '~> 0.10.0'
gem 'cucumber'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'awesome_print'
end

group :development do
  gem 'rubocop', require: false
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec-its'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'rspec-json_matcher'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
