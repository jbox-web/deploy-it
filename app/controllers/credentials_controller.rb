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

    add_crumb label_with_icon(t('label.repository_credential.new'), 'fa-lock', fixed: true), applications_path
  end


  def edit
    @credential_form = CredentialUpdateForm.new(@credential)

    add_crumb label_with_icon(@credential.name, 'fa-lock', fixed: true), applications_path
    add_crumb t('label.edit'), '#'
  end


  def create
    @credential = type_class.new
    @credential_form = CredentialCreationForm.new(@credential)
    @credential_form.submit(credential_create_params)

    if @credential_form.save
      flash[:notice] = t('notice.repository_credential.created')
      redirect_to applications_path
    else
      add_crumb label_with_icon(t('label.repository_credential.new'), 'fa-lock', fixed: true), applications_path
      render :new
    end
  end


  def update
    @credential_form = CredentialUpdateForm.new(@credential)
    @credential_form.submit(credential_update_params)

    if @credential_form.save
      flash[:notice] = t('notice.repository_credential.updated')
      redirect_to applications_path
    else
      add_crumb label_with_icon(@credential.name, 'fa-lock', fixed: true), applications_path
      add_crumb t('label.edit'), '#'
      render :edit
    end
  end


  def destroy
    if @credential.destroy
      flash[:notice] = t('notice.repository_credential.deleted')
    else
      flash[:alert] = @credential.errors.full_messages
    end
    redirect_to applications_path
  end


  private


    def type
      [ 'RepositoryCredential::BasicAuth', 'RepositoryCredential::SshKey' ].include?(params[:repository_credential][:type]) ? params[:repository_credential][:type] : 'RepositoryCredential'
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

end
