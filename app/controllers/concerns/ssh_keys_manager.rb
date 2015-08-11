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
    before_action :find_user
    before_action :find_user_ssh_keys
    before_action :find_ssh_key, only: :destroy
  end


  def index
    @ssh_key = SshPublicKey.new
  end


  def create
    @ssh_key = SshPublicKey.new(ssh_key_params.merge(user_id: @user.id))
    @ssh_key.save ? render_success : render_failed
  end


  def destroy
    request.delete? && @ssh_key.destroy ? render_success : render_failed
  end


  private


    def render_success
      flash[:notice] = t('.notice')
      # Call service objects to perform other actions
      call_service_objects
      # Reset form object
      @ssh_key = SshPublicKey.new
      render_ajax_response(locals: { user: @user, ssh_keys: @ssh_keys, ssh_key: @ssh_key})
    end


    def render_failed
      flash[:error] = t('.error')
      render_ajax_response(locals: { user: @user, ssh_keys: @ssh_keys, ssh_key: @ssh_key})
    end


    def ssh_key_params
      params.require(:ssh_public_key).permit(:title, :key)
    end


    def call_service_objects
      case action_name
      when 'create'
        result = @ssh_key.add_to_authorized_keys!
      when 'destroy'
        result = @ssh_key.remove_from_authorized_keys!
      end
      flash[:alert] = result.errors if !result.success?
    end


    def find_user
      raise NotImplementedError
    end


    def find_ssh_key
      @ssh_key = @user.ssh_public_keys.find_by_id(params[:id])
    end


    def find_user_ssh_keys
      @ssh_keys = @user.ssh_public_keys
    end

end
