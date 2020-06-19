# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.14.1'

## Base
set :application,    'deploy-it'
set :repo_url,       'https://github.com/jbox-web/deploy-it.git'
set :deploy_to,      '/home/deploy-it/deploy-it'
set :deploy_it_home, '/home/deploy-it'

## SSH
set :ssh_options, {
  keys:          [File.join(Dir.home, '.ssh', 'id_rsa')],
  forward_agent: true,
  auth_methods:  %w(publickey)
}

## rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.6.6'

## Bundler
set :bundle_flags,   ''
set :bundle_path,    nil
set :bundle_without, nil

## Rails
append :linked_files, '.env'
append :linked_dirs,  'log', 'tmp'

# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to :db role
set :migration_role, :app

# Cleanup assets after deploy
set :keep_assets, 1

## Foreman
set :foreman_roles,       :app
set :foreman_init_system, 'systemd'
set :foreman_services,    %w(web worker)
set :foreman_export_path, "#{fetch(:deploy_it_home)}/.config/systemd/user"
set :foreman_options,     {
  template: "#{fetch(:deploy_it_home)}/.foreman/templates/systemd",
  root:     current_path,
  timeout:  30,
}

## Config
set :config_templates, %w(nginx syslog logrotate)
set :config_syslog, %w(web worker)

## Nginx
set :nginx_vhost, {
  domain: 'rename_me.net',
  ssl: false
}

namespace :deploy do
  before 'deploy:check',              'maintenance:start'
  before 'deploy:check:linked_files', 'config:generate'
  after  'deploy:check:linked_files', 'foreman:install'
  after  'deploy:check:linked_files', 'maintenance:install'
  after  'deploy:check:linked_files', 'favicon:install'
  # after  'deploy:published',          'bundler:clean'
  after  'deploy:finished',           'foreman:export'
  after  'deploy:finished',           'foreman:restart'
  after  'deploy:finished',           'maintenance:end'
end
