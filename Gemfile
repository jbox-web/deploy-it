source 'https://rubygems.org'
ruby '2.4.1'

gem 'rugged',                '~> 0.25.0', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.25.1', submodules: true

gem 'async_notifications',   '~> 1.0.0',  git: 'https://github.com/jbox-web/async_notifications.git', tag: '1.0.0'
gem 'active_use_case',       '~> 1.2.0',  git: 'https://github.com/jbox-web/active_use_case.git', tag: '1.2.0'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

# Base gems
gem 'rails', '~> 5.1'

# Bundler for Rails Assets
gem 'bundler', '>= 1.8.4'

source 'https://rails-assets.org' do
  # HighCharts
  gem 'rails-assets-highstock-release'

  # DateTime Picker
  gem 'rails-assets-datetimepicker'
end

# Server
gem 'puma'

# Database
gem 'mysql2'
gem 'pg'

# Authentication
gem 'bcrypt'
gem 'devise'

# Configuration
gem 'dotenv-rails'
gem 'figaro'
gem 'settingslogic'
gem 'foreman'

# Javascript
gem 'mini_racer'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'uglifier'

# CSS
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Fonts
gem 'font-awesome-sass'
gem 'font-awesome-rails'

# Forms
gem 'bootstrap_form'
gem 'nested_form'
gem 'actionform', git: 'https://github.com/jbox-web/actionform.git', require: 'action_form'

# Bootstrap addons
gem 'bootstrap-switch-rails'
gem 'bootstrap-slider-rails'

# View rendering
gem 'haml-rails'

# Pagination
gem 'smart_listing'
gem 'ajax-datatables-rails'

# Breadcrumbs
gem 'crummy'

# Code edition
gem 'codemirror-rails'

# Copy/Past
gem 'zeroclipboard-rails'

# Select2
gem 'select2-rails'

# Statistics
gem 'chartkick'
gem 'groupdate'

# Menus
gem 'simple-navigation'
gem 'simple_navigation_bootstrap'
gem 'rails_bootstrap_navbar'

# Sortable lists
gem 'acts_as_list'

# Translations
gem 'i18n-tasks'

# Docker connection
gem 'docker-api'

# Render Docker top
gem 'tty-table'

# SSH Keys generation
gem 'sshkey'

# Presence check over SSH
gem 'net-ssh'

# Docker builds are state machines
gem 'aasm'

# Redis
gem 'redis'
gem 'hiredis'
gem 'redis-namespace'

# Async Jobs
gem 'sidekiq'

# Use Syslog to manage our logs
gem 'syslogger'

# Async Notifications
gem 'bootstrap-growl-rails'

# Cache
gem 'redis-rails'

# Rails Application Logs
gem 'logster'

# Profiler
gem 'rack-mini-profiler'

# External API
gem 'grape'
gem 'hashie-forbidden_attributes'

# Speedup application loading
gem 'bootsnap'

# Be notified of exceptions in production
gem 'exception_notification'

# The `content_tag_for` method has been removed from Rails
gem 'record_tag_helper'

## Documentation gems
group :doc do
  gem 'sdoc'
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'

  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'shoulda-context'

  gem 'faker'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'

  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'

  # Code coverage
  gem 'simplecov'

  # Code coverage for CodeClimate
  gem 'codeclimate-test-reporter', require: false
end

group :development do
  # Rails test server
  gem 'spring'
  gem 'spring-commands-rspec'

  # Deployment
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-foreman'
  gem 'capistrano-template'

  # Email preview
  gem 'letter_opener_web'

  # SQL Queries optimizer
  gem 'bullet'

  # Security analysis
  gem 'brakeman'

  # Code analyzer
  gem 'rubocop',    require: false
  gem 'rubycritic', require: false

  # Generate Entity-Relationship Diagrams
  gem 'rails-erd'
end
