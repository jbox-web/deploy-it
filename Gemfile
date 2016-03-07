source 'https://rubygems.org'
ruby '2.2.4'

gem 'rugged',                '~> 0.23.3', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.23.3', submodules: true
gem 'actionform',            '~> 0.0.1',  git: 'https://github.com/rails/actionform.git', require: 'action_form'

gem 'async_notifications',   '~> 1.0.0',  git: 'https://github.com/jbox-web/async_notifications.git', tag: '1.0.0'
gem 'active_use_case',       '~> 1.0.3',  git: 'https://github.com/jbox-web/active_use_case.git'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

gem 'simple_navigation_renderers', '~> 1.0.2', git: 'https://github.com/n-rodriguez/simple_navigation_renderers.git', branch: 'fix_rails4'

# Base gems
gem 'rails', '~> 4.2.5'

# Bundler for Rails Assets
gem 'bundler', '>= 1.8.4'

source 'https://rails-assets.org' do
  # HighCharts
  gem 'rails-assets-highstock-release'

  # DateTime Picker
  gem 'rails-assets-datetimepicker'
end

# Server
gem 'puma', '~> 3.1.0'

# Database
gem 'mysql2', '~> 0.4.1'
gem 'pg',     '~> 0.18.2'

# Authentication
gem 'bcrypt',        '~> 3.1.10'
gem 'devise',        '~> 3.5.1'
gem 'request_store', '~> 1.3.0'

# Configuration
gem 'dotenv-rails'
gem 'figaro'
gem 'settingslogic'

# Javascript
gem 'coffee-rails',    '~> 4.1.0'
gem 'jquery-rails',    '~> 4.1.0'
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'turbolinks',      '~> 2.5.3'
gem 'uglifier',        '~> 2.7.1'

# Fonts
gem 'font-awesome-rails'
gem 'octicons-rails'
gem 'google-webfonts-rails'

# CSS
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Forms
gem 'bootstrap_form',         '~> 2.3.0'
gem 'bootstrap-switch-rails', '~> 3.3.2'
gem 'bootstrap-slider-rails', '~> 5.3.3'
gem 'nested_form',            '~> 0.3.2'

# View rendering
gem 'haml-rails'

# Pagination
gem 'smart_listing', '~> 1.1.2'
gem 'ajax-datatables-rails', git: 'https://github.com/n-rodriguez/ajax-datatables-rails.git', branch: 'v-0-4-0'

# Breadcrumbs
gem 'crummy', '~> 1.8.0'

# Code edition
gem 'codemirror-rails', '~> 5.6.0'

# Copy/Past
gem 'zeroclipboard-rails', '~> 0.1.1'

# Select2
gem 'select2-rails', '~> 4.0.0'

# Statistics
gem 'chartkick', '~> 1.4.1'
gem 'groupdate', '~> 2.5.0'

# Menus
gem 'simple-navigation', '~> 4.0.0'

# Sortable lists
gem 'acts_as_list', '~> 0.7.0'

# Translations
gem 'i18n-tasks', '~> 0.9.0'

# Docker connection
gem 'docker-api', '~> 1.24.0', git: 'https://github.com/n-rodriguez/docker-api.git', branch: 'top-add-format-option'

# Render Docker top
gem 'tty-table'

# SSH Keys generation
gem 'sshkey', '~> 1.8.0'

# Presence check over SSH
gem 'net-ssh', '~> 3.0.1'

# Docker builds are state machines
gem 'aasm', '~> 4.9.0'

# Async Jobs
gem 'sidekiq', '~> 4.1.0'
gem 'sinatra', require: false
gem 'slim'

# Async Notifications
gem 'danthes',    '~> 2.0.1', git: 'https://github.com/dotpromo/danthes.git'
gem 'thin',       '~> 1.6.3'
gem 'faye-redis', '~> 0.2.0'
gem 'bootstrap-growl-rails', '~> 3.1.3'

# Cache
gem 'redis-rails'

# Rails Application Logs
gem 'redis'
gem 'logster'

# Profiler
gem 'rack-mini-profiler'

# External API
gem 'grape', '~> 0.14.0'
gem 'hashie-forbidden_attributes'

## Documentation gems
group :doc do
  gem 'sdoc', '~> 0.4.0'
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

  gem 'mina',         '~> 0.3.4'
  gem 'mina-puma',    require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-scp',     require: false

  # gem 'brakeman', '~> 2.6.3'
  # gem 'bullet'
end
