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

class CredentialCreationForm < ActionForm::Base

  CREATION_OPTIONS = [
    ['generate', I18n.t('label.repository_credential.generate_key')],
    ['manual',   I18n.t('label.repository_credential.specify_key')]
  ]

  AVAILABLE_CREDENTIALS = [
    ['RepositoryCredential::BasicAuth', I18n.t('label.repository_credential.basic_auth')],
    ['RepositoryCredential::SshKey',    I18n.t('label.repository_credential.ssh_key')]
  ]

  self.main_model = :credential

  ## Real attributes
  attribute :name,        required: false
  attribute :type,        required: false
  attribute :login,       required: false
  attribute :password,    required: false
  attribute :public_key,  required: false
  attribute :private_key, required: false
  attribute :generated,   required: false

  ## Virtual attributes (options)
  attr_accessor :create_options

  ## Validations
  validates :create_options, presence: true,
                             inclusion: { in: ['generate', 'manual'] },
                             if: :credential_is_ssh_key?

  ## Override inherited method to assign virtual attributes (attr_accessor).
  ## (kind of alias_method_chain)
  def submit(params)
    super
    if type == 'RepositoryCredential::SshKey' && automatic_mode?
      data = DeployIt::Utils::Ssh.generate_ssh_key
      self.generated   = data[:generated]
      self.public_key  = data[:public_key]
      self.private_key = data[:private_key]
    end
  end


  private


    def automatic_mode?
      create_options == 'generate'
    end


    def credential_is_ssh_key?
      type == 'RepositoryCredential::SshKey'
    end

end
