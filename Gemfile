source 'https://rubygems.org'
ruby '2.1.1'
#ruby-gemset=rails_4_tutorial

gem 'rails', '4.0.8'
gem 'bootstrap-sass', '2.3.2.0'
gem 'sprockets', '2.11.0'           # Ruby library for compiling and serving web assets
gem 'bcrypt-ruby', '3.1.2'          # bcrypt() password hashing algorithm, allowing you to easily store a secure hash of your users' passwords
# gem 'bcrypt-ruby', '~> 3.0.0'
gem 'faker', '1.1.2'                # allow us to make sample users with semi-realistic names and email addresses
gem 'will_paginate', '3.0.4'        # a collection of extensions for the database layer that enable paginated queries, and view helpers for popular frameworks that render pagination links
gem 'bootstrap-will_paginate', '0.0.9' # configures will_paginate to use Bootstrap’s pagination styles


gem 'do_by', github: 'andyw8/do_by'   # Automatically expiring TODO notes in Ruby

group :development, :test do
  gem 'sqlite3', '1.3.8'
  gem 'rspec-rails', '2.13.1'       # rspec: integration tests
  gem 'guard-rspec', '2.5.0'        # guard: automate the running of the tests by detecting file modifications
  gem 'spork-rails', '4.0.0'        # spork: server for testing frameworks (RSpec / Cucumber) that forks before each run to ensure a clean testing state and to speed up tests
  gem 'guard-spork', '1.5.0'        # spork: server for testing -> guard + spork
  gem 'childprocess', '0.3.6'       # spork: server for testing
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'           # natural-language DSL for rspec
  gem 'libnotify', '0.8.0'          # guard: notifications add-on
  gem 'factory_girl_rails', '4.2.0' # A library for setting up Ruby objects as test data
  gem 'cucumber-rails', '1.4.0', :require => false            # behavior-driven development
  gem 'database_cleaner', github: 'bmabey/database_cleaner'   # utility for cucumber
end

gem 'sass-rails', '4.0.1'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'                # PostgreSQL 
  gem 'rails_12factor', '0.0.2'
end


# TODO:
# pry
# gems "learn-rails"
# gems "sample_app"
# gems "coursera"
# gem "analytics"
# gem "mailing"
# nokogiri?
# Rails 4 by Obie Fernandez
# RubyToolkit top