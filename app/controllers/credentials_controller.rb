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

class CredentialsController < DCIController

  set_dci_role 'DCI::Roles::RepositoryCredentialsManager'

  before_action :authorize_global
  before_action :set_credential,  only: [:edit, :update, :destroy]
  before_action :add_breadcrumbs, except: [:index, :show]


  def index
    render_404
  end


  def show
    render_404
  end


  def new
    @credential = CredentialCreationForm.new(RepositoryCredential.new)
    render locals: { credential: @credential }
  end


  def edit
  end


  def create
    set_dci_data({ repository_credential: [:name, :type, :login, :password, :public_key, :private_key, :create_options] })
    call_dci_role(:create_credential)
  end


  def update
    set_dci_data({ credential_hash => [:name, :login, :password] })
    call_dci_role(:update_credential, @credential)
  end


  def destroy
    call_dci_role(:delete_credential, @credential) if request.delete?
  end


  private


    def credential_hash
      @credential.type.underscore.gsub('/', '_').to_sym
    end


    def render_dci_response(template:, type:, locals: {}, &block)
      if destroy_action? || success_create?(type) || success_update?(type)
        super { redirect_to applications_path }
      else
        super
      end
    end


    def add_breadcrumbs(type: action_name)
      case type
      when 'new', 'create'
        add_breadcrumb t('.title'), 'fa-lock', applications_path
      when 'edit', 'update'
        add_breadcrumb @credential.name, 'fa-lock', applications_path
        add_crumb t('text.edit'), '#'
      end
    end

end
