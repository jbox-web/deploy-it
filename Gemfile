# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

# Base gems
gem 'rails', '~> 5.2'

gem 'rugged',                '~> 1.0.0', github: 'libgit2/rugged', tag: 'v1.0.0', submodules: true

gem 'async_notifications',   '~> 1.0.0',  github: 'jbox-web/async_notifications', tag: '1.0.0'
gem 'active_use_case',       '~> 1.3.0',  github: 'jbox-web/active_use_case', tag: '1.3.0'
gem 'async_model',           '~> 1.0.0',  github: 'jbox-web/async_model'

source 'https://rails-assets.org' do
  # HighCharts
  gem 'rails-assets-highstock-release'

  # DateTime Picker
  gem 'rails-assets-datetimepicker'
end

platforms :mri do
  # Speedup application loading
  gem 'bootsnap', require: false

  # Speedup blank? method
  gem 'fast_blank'

  # symbol.to_s returns frozen string
  gem 'symbol-fstring', require: 'fstring/all'

  # Boost JSON generation
  gem 'yajl-ruby', require: 'yajl/json_gem'

  # Database
  gem 'mysql2'
  gem 'pg'

  # Javascript
  gem 'uglifier'
  gem 'mini_racer'
end

# Server
gem 'puma'

# Authentication
gem 'bcrypt'
gem 'devise'

# Configuration
gem 'dotenv-rails'
gem 'figaro'
gem 'settingslogic'
gem 'foreman', github: 'jbox-web/foreman'

# Javascript
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'

# CSS
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Fonts
gem 'font-awesome-sass'
gem 'font-awesome-rails'

# Forms
gem 'bootstrap_form', '2.7.0'
gem 'nested_form'
gem 'action_form', github: 'jbox-web/action_form'

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
gem 'docker-api', '1.34.2'

# Render Docker top
gem 'tty-table'

# SSH Keys generation
gem 'sshkey'

# Presence check over SSH
gem 'net-ssh'

# Docker builds are state machines
gem 'aasm'
gem 'after_commit_everywhere'

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
  gem 'factory_bot_rails'
  gem 'database_cleaner'

  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'

  # Code coverage
  gem 'simplecov'
end

group :development do
  # Rails test server
  gem 'spring'
  gem 'spring-commands-rspec'

  # Deployment
  gem 'capistrano'
  gem 'capistrano-rbenv'
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

  # Squash DB migrations
  gem 'squasher'
end
