# frozen_string_literal: true
# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

require 'sidekiq/web'

Rails.application.routes.draw do

  root 'welcome#index'

  ### All routes below this point should require login ###

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  mount ActionCable.server, at: '/cable'

  ## Devise routes
  devise_for :users,
             skip_helpers: [:registrations],
             controllers: { sessions: 'sessions', registrations: 'registrations' },
             path_names: { sign_in: 'login', sign_out: 'logout' }

  as :user do
    get   'my/password', to: 'registrations#edit',   as: 'edit_user_registration'
    patch 'my/password', to: 'registrations#update', as: 'user_registration'
  end

  ## Help section
  get 'help', to: 'welcome#help', as: 'help'

  ## User edit profile
  scope 'my' do
    resources :public_keys, only: [:index, :create, :destroy]
    match 'account',       to: 'my#account',       as: 'my_account', via: [:get, :patch]
    match 'notifications', to: 'my#notifications', as: 'my_notifications', via: [:get]
    match 'reset_api_key', to: 'my#reset_api_key', as: 'reset_api_key', via: [:patch]
  end

  ## DeployIt Authentifier
  constraints IpWhiteList.new do
    post 'deploy_it/auth',  to: 'deploy_it_auth#index'
    post 'deploy_it/ident', to: 'deploy_it_ident#index'
  end

  resources :credentials
  scope '/credentials' do
    resources :basic_auths, controller: 'credentials'
    resources :ssh_keys,    controller: 'credentials'
  end

  # Applications base
  resources :applications, except: [:edit, :update] do
    member do
      get 'infos', action: 'show'
      get 'activities'
      get 'events'
      get 'containers'
      get 'repositories'
    end
    resources :members, except: [:new, :show]
  end

  # Applications Manager
  resources :applications, only: [], controller: 'applications_manager' do
    member do
      get   'status'
      get   'toolbar'
      post  'build'
      post  'manage'
    end
    resources :containers, only: [], controller: 'containers_manager' do
      member do
        get   'infos'
        get   'top'
        match 'events', via: [:get, :post]
        post  'manage'
        post  'mark_events'
      end
    end
  end

  post 'events/:id/mark_event', to: 'container_events#mark_event', as: 'mark_event'

  # Applications Charts
  resources :applications, only: [], controller: 'charts' do
    member { get 'charts' }
  end

  # Applications Config
  resources :applications, only: [], controller: 'applications_config' do
    member do
      get 'restore_env_vars'
      get 'restore_mount_points'
      get 'reset_database'
      get 'reset_ssl_certificate'
      get 'synchronize_repository'

      post 'toggle_ssl'
      post 'toggle_credentials'

      match 'addons',          via: [:get, :patch]
      match 'add_addon',       via: [:get, :post]
      match 'credentials',     via: [:get, :patch]
      match 'database',        via: [:get, :patch]
      match 'domain_names',    via: [:get, :patch]
      match 'env_vars',        via: [:get, :patch]
      match 'mount_points',    via: [:get, :patch]
      match 'repository',      via: [:get, :patch]
      match 'settings',        via: [:get, :patch]
      match 'ssl_certificate', via: [:get, :patch]
    end
  end

  ## Admin section
  namespace :admin do
    root to: 'dashboard#index'

    resources :application_types do
      member { get 'clone' }
    end

    resources :users do
      ## Administrators can create SSH keys for users
      resources :public_keys, only: [:index, :create, :destroy]

      ## Administrators can also manage memberships for users
      resources :memberships, except: [:new, :show]

      member do
        ## Administrators can change password for users
        match 'change_password', as: 'change_password', via: [:get, :patch]
      end
    end

    resources :groups
    resources :docker_images
    resources :addons
    resources :buildpacks
    resources :reserved_names

    resources :locks,    only: [:index, :destroy]
    resources :settings, only: [:index]

    resources :applications, only: [:index] do
      get 'status'
      collection do
        post 'manage'
      end
    end

    resources :roles do
      collection do
        post  'sort'
        match 'permissions', via: [:get, :post]
      end
    end

    resources :platforms do
      collection { get 'stages' }

      resources :stages

      resources :servers do
        member do
          get   'status'
          patch 'enable_role'
          patch 'disable_role'
          patch 'update_roles'
        end
      end
    end

  end ## End of Admin section

end
