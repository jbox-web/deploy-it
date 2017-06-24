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

module SshKeysManager
  extend ActiveSupport::Concern

  included do
    include DCI::Controllers::Account
    set_dci_role 'DCI::Roles::AccountManager'

    before_action :set_user
    before_action :set_ssh_key, only: :destroy
  end


  def index
    add_breadcrumb get_model_name_for('SshPublicKey'), 'fa fa-key fa-lg', ''
  end


  def create
    set_dci_data({ ssh_public_key: [:title, :key] })
    call_dci_role(:create_ssh_key)
  end


  def destroy
    call_dci_role(:delete_ssh_key, @ssh_key) if request.delete?
  end


  private


    def set_user
      raise NotImplementedError
    end


    def set_ssh_key
      @ssh_key = @user.ssh_public_keys.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end

end
