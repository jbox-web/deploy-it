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

class CredentialsController < ApplicationController

  before_action :authorize_global
  before_action :set_credential, only: [:edit, :update, :destroy]


  def index
    render_404
  end


  def show
    render_404
  end


  def new
    @credential = RepositoryCredential.new
    @credential_form = CredentialCreationForm.new(@credential)
    add_breadcrumbs
  end


  def edit
    add_breadcrumbs
  end


  def create
    @credential = type_class.new
    @credential_form = CredentialCreationForm.new(@credential)
    @credential_form.submit(credential_create_params)
    if @credential_form.save
      render_success
    else
      add_breadcrumbs
      render :new
    end
  end


  def update
    if @credential.update(credential_update_params)
      render_success
    else
      add_breadcrumbs
      render :edit
    end
  end


  def destroy
    @credential.destroy ? render_success : render_failed
  end


  private


    def type
      accepted_klasses.include?(params[:repository_credential][:type]) ? params[:repository_credential][:type] : default_klass
    end


    def default_klass
      'RepositoryCredential'
    end


    def accepted_klasses
      ['RepositoryCredential::BasicAuth', 'RepositoryCredential::SshKey']
    end


    def type_class
      type.constantize
    end


    def set_credential
      @credential = RepositoryCredential.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def credential_create_params
      params.require(:repository_credential).permit(:name, :type, :login, :password, :public_key, :private_key, :create_options)
    end


    def credential_update_params
      params.require(@credential.type.underscore.gsub('/', '_').to_sym).permit(:name, :login, :password)
    end


    def render_success
      redirect_to applications_path, notice: t('.notice')
    end


    def render_failed
      redirect_to applications_path, alert: @credential.errors.full_messages
    end


    def add_breadcrumbs(type: action_name)
      case type
      when 'new', 'create'
        add_crumb label_with_icon(t('.title'), 'fa-lock', fixed: true), applications_path
      when 'edit', 'update'
        add_crumb label_with_icon(@credential.name, 'fa-lock', fixed: true), applications_path
        add_crumb t('text.edit'), '#'
      end
    end

end
