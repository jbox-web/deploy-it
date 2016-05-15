source 'https://rubygems.org'
ruby '2.3.1'

gem 'rugged',                '~> 0.24.0', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.24.0', submodules: true
gem 'actionform',            '~> 0.0.1',  git: 'https://github.com/rails/actionform.git', require: 'action_form'

gem 'async_notifications',   '~> 1.0.0',  git: 'https://github.com/jbox-web/async_notifications.git', tag: '1.0.0'
gem 'active_use_case',       '~> 1.0.3',  git: 'https://github.com/jbox-web/active_use_case.git', tag: '1.0.3'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

gem 'simple_navigation_renderers', '~> 1.0.2', git: 'https://github.com/n-rodriguez/simple_navigation_renderers.git', branch: 'fix_rails4'

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
gem 'turbolinks'
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
gem 'sinatra', require: false
gem 'slim'

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

  gem 'shoulda',          '~> 3.5.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'shoulda-context',  '~> 1.2.1'

  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'

  gem 'capybara'

  # Code coverage
  gem 'simplecov'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'turbulence'
  gem 'flog'
  gem 'quiet_assets'

  gem 'mina'
  gem 'mina-puma',    require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-scp',     require: false

  # gem 'brakeman', '~> 2.6.3'
  # gem 'bullet'
end
