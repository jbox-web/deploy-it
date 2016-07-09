source 'https://rubygems.org'
ruby '2.3.1'

gem 'rugged',                '~> 0.24.0', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.24.0', submodules: true

gem 'async_notifications',   '~> 1.0.0',  git: 'https://github.com/jbox-web/async_notifications.git', tag: '1.0.0'
gem 'active_use_case',       '~> 1.0.3',  git: 'https://github.com/jbox-web/active_use_case.git', tag: '1.0.3'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

gem 'actionform', git: 'https://github.com/jbox-web/actionform.git', require: 'action_form'

# Base gems
gem 'rails', '~> 4.2.6'

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
gem 'request_store'

# Configuration
gem 'dotenv-rails'
gem 'figaro'
gem 'settingslogic'

# Javascript
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', git: 'https://github.com/turbolinks/turbolinks-classic.git'
gem 'uglifier'

# Fonts
gem 'font-awesome-rails'
gem 'octicons-rails'
gem 'google-webfonts-rails'

# CSS
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Forms
gem 'bootstrap_form'
gem 'bootstrap-switch-rails'
gem 'bootstrap-slider-rails'
gem 'nested_form'

# View rendering
gem 'haml-rails'

# Pagination
gem 'smart_listing'
gem 'ajax-datatables-rails', git: 'https://github.com/n-rodriguez/ajax-datatables-rails.git', branch: 'v-0-4-0'

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

# Sortable lists
gem 'acts_as_list'

# Translations
gem 'i18n-tasks'

# Docker connection
gem 'docker-api', '~> 1.24.0', git: 'https://github.com/n-rodriguez/docker-api.git', branch: 'top-add-format-option'

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
gem 'em-synchrony'
gem 'redis-namespace'

# Async Jobs
gem 'sidekiq'

# Async Notifications
gem 'danthes', '~> 2.0.1', git: 'https://github.com/dotpromo/danthes.git'
gem 'thin'
gem 'faye-redis'
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

  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'

  gem 'capybara'

  # Code coverage
  gem 'simplecov'

  # Code coverage for CodeClimate
  gem 'codeclimate-test-reporter', require: false
end

group :development do
  # Rails test server
  gem 'spring'
  gem 'spring-commands-rspec'

  # Remove assets logs from console
  gem 'quiet_assets'

  # Deployment
  gem 'mina'
  gem 'mina-scp', require: false

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
