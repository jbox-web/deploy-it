source 'https://rubygems.org'
ruby '2.2.1'

gem 'rugged',                '~> 0.23.2', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.23.2', submodules: true
gem 'actionform',            '~> 0.0.1',  git: 'https://github.com/rails/actionform.git', require: 'action_form'

gem 'async_notifications',   '~> 1.0.0',  git: 'https://github.com/jbox-web/async_notifications.git', tag: '1.0.0'
gem 'active_use_case',       '~> 1.0.3',  git: 'https://github.com/jbox-web/active_use_case.git'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

gem 'simple_navigation_renderers', '~> 1.0.2', git: 'https://github.com/n-rodriguez/simple_navigation_renderers.git', branch: 'fix_rails4'

# Base gems
gem 'rails', '~> 4.2.4'

# Bundler for Rails Assets
gem 'bundler', '>= 1.8.4'

source 'https://rails-assets.org' do
  # HighCharts
  gem 'rails-assets-highstock-release'

  # DateTime Picker
  gem 'rails-assets-datetimepicker'
end

# Server
gem 'puma',           '~> 2.14.0'
gem 'secure_headers', '~> 2.4.0'

# Database
gem 'mysql2', '~> 0.3.20'
gem 'pg',     '~> 0.18.2'

# Authentication
gem 'bcrypt',        '~> 3.1.10'
gem 'devise',        '~> 3.5.1'
gem 'request_store', '~> 1.2.0'

# Configuration
gem 'dotenv-rails',  '~> 2.0.2'
gem 'figaro',        '~> 1.1.0'
gem 'settingslogic', '~> 2.0.9'

# Javascript
gem 'coffee-rails',    '~> 4.1.0'
gem 'jquery-rails',    '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'turbolinks',      '~> 2.5.3'
gem 'uglifier',        '~> 2.7.1'

# Fonts
gem 'font-awesome-rails',    '~> 4.4.0'
gem 'octicons-rails',        '~> 2.1.1'
gem 'google-webfonts-rails', '~> 0.0.4'

# CSS
gem 'sass-rails',         '~> 5.0.3'
gem 'bootstrap-sass',     '~> 3.3.4'
gem 'autoprefixer-rails', '~> 6.0.0'

# Forms
gem 'bootstrap_form',         '~> 2.3.0'
gem 'bootstrap-switch-rails', '~> 3.3.2'
gem 'bootstrap-slider-rails', '~> 5.2.4'
gem 'nested_form',            '~> 0.3.2'

# View rendering
gem 'haml-rails', '~> 0.9.0'

# Pagination
gem 'smart_listing', '~> 1.1.2'

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
gem 'i18n-tasks', '~> 0.8.0'

# Docker connection
gem 'docker-api', '~> 1.22.2'

# SSH Keys generation
gem 'sshkey', '~> 1.7.0'

# Presence check over SSH
gem 'net-ssh', '~> 3.0.1'

# Docker builds are state machines
gem 'aasm', '~> 4.3.0'

# Async Jobs
gem 'sidekiq', '~> 3.5.0'
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
gem 'grape', '~> 0.13.0'
gem 'hashie-forbidden_attributes'

## Documentation gems
group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :test, :development do
  gem 'rspec',       '~> 3.3.0'
  gem 'rspec-rails', '~> 3.3.0'

  gem 'shoulda',          '~> 3.5.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'shoulda-context',  '~> 1.2.1'

  gem 'factory_girl',       '~> 4.5.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker',              '~> 1.5.0'
  gem 'database_cleaner',   '~> 1.5.0'

  gem 'capybara', '~> 2.5.0'

  # Code coverage
  gem 'simplecov', '~> 0.10.0'
end

group :development do
  gem 'spring',                '~> 1.4.0'
  gem 'spring-commands-rspec', '~> 1.0.4'

  gem 'turbulence',   '~> 1.2.4'
  gem 'flog',         '~> 4.3.0'
  gem 'quiet_assets', '~> 1.1.0'

  gem 'mina',         '~> 0.3.4'
  gem 'mina-puma',    require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-scp',     require: false

  # gem 'brakeman', '~> 2.6.3'
  # gem 'bullet',   '~> 4.14.7'
end
