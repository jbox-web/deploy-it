source 'https://rubygems.org'

gem 'rugged',                '~> 0.22.2', git: 'https://github.com/libgit2/rugged.git', tag: 'v0.22.2', submodules: true
gem 'actionform',            '~> 0.0.1',  git: 'https://github.com/rails/actionform.git', require: 'action_form'

gem 'async_notifications',   '~> 0.1.0',  git: 'https://github.com/jbox-web/async_notifications.git'
gem 'active_use_case',       '~> 1.0.3',  git: 'https://github.com/jbox-web/active_use_case.git'
gem 'async_model',           '~> 1.0.0',  git: 'https://github.com/jbox-web/async_model.git'

gem 'simple_navigation_renderers', '~> 1.0.2', git: 'https://github.com/n-rodriguez/simple_navigation_renderers.git', branch: 'fix_rails4'

## Base gems
gem 'rails',          '~> 4.2.3'
gem 'bcrypt',         '~> 3.1.10'
gem 'devise',         '~> 3.5.1'
gem 'puma',           '~> 2.12.0'
gem 'secure_headers', '~> 2.2.1'

## Database
gem 'mysql2', '~> 0.3.19'
gem 'pg',     '~> 0.18.2'

## Interface gems
# Javascript
gem 'coffee-rails',    '~> 4.1.0'
gem 'jquery-rails',    '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'therubyracer',    '~> 0.12.1'
gem 'turbolinks',      '~> 2.5.3'
gem 'uglifier',        '~> 2.7.1'
gem 'libv8',           '3.16.14.7'

# Fonts
gem 'font-awesome-rails',    '~> 4.4.0'
gem 'octicons-rails',        '~> 2.1.1'
gem 'google-webfonts-rails', '~> 0.0.4'

# CSS
gem 'sass-rails',         '~> 5.0.3'
gem 'bootstrap-sass',     '~> 3.3.4'
gem 'autoprefixer-rails', '~> 5.2.1'

# View rendering
gem 'crummy',                      '~> 1.8.0'
gem 'bootstrap_form',              '~> 2.3.0'
gem 'bootstrap-growl-rails',       '~> 3.0.0'
gem 'bootstrap-switch-rails',      '~> 3.3.2'
gem 'codemirror-rails',            '~> 5.5.0'
gem 'haml-rails',                  '~> 0.9.0'
gem 'select2-rails',               '~> 3.5.9'
gem 'simple-navigation',           '~> 4.0.0'
gem 'will_paginate',               '~> 3.0.7'
gem 'will_paginate-bootstrap',     '~> 1.0.1'
gem 'zeroclipboard-rails',         '~> 0.1.1'

## Utils gems
gem 'acts_as_list',  '~> 0.7.0'
gem 'carrierwave',   '~> 0.10.0'
gem 'figaro',        '~> 1.1.0'
gem 'i18n-tasks',    '~> 0.8.0'
gem 'nested_form',   '~> 0.3.2'
gem 'request_store', '~> 1.2.0'
gem 'settingslogic', '~> 2.0.9'
gem 'whenever',      '~> 0.9.4'

## Business required gems
# Docker connection
gem 'docker-api', '~> 1.22.2'

# SSH Keys generation
gem 'sshkey', '~> 1.7.0'

# Presence check over SSH
gem 'net-ssh', '~> 2.9.2'

# Docker builds are state machines
gem 'aasm', '~> 4.2.0'

# Async Jobs
gem 'sidekiq', '~> 3.4.1'
gem 'sinatra', require: false
gem 'slim'

# Async Notifications
gem 'danthes',    '~> 2.0.1', git: 'https://github.com/n-rodriguez/danthes.git', branch: 'feat_add_options'
gem 'thin',       '~> 1.6.3'
gem 'faye-redis', '~> 0.2.0'

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
  gem 'rspec', '~> 3.3.0'
  gem 'rspec-rails', '~> 3.3.0'

  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'shoulda-context', '~> 1.2.1'

  gem 'factory_girl', '~> 4.5.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.2'
  gem 'database_cleaner', '~> 1.4.1'

  gem 'capybara', '~> 2.4.4'

  # Code coverage
  gem 'simplecov', '~> 0.10.0'
  gem 'simplecov-rcov', '~> 0.2.3'

  # Junit results
  gem 'ci_reporter_rspec', '~> 1.0.0'
end

group :development do
  gem 'spring',                '~> 1.3.1'
  gem 'spring-commands-rspec', '~> 1.0.4'

  gem 'turbulence',   '~> 1.2.4'
  gem 'flog',         '~> 4.3.0'
  gem 'mina',         '~> 0.3.4'
  gem 'quiet_assets', '~> 1.1.0'

  # gem 'brakeman', '~> 2.6.3'
  # gem 'bullet',   '~> 4.14.7'
end
