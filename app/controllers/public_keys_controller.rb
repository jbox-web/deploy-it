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

class PublicKeysController < ApplicationController

  before_action :find_user_ssh_keys
  before_action :find_ssh_key, only: :destroy


  def index
    set_form_object
  end


  def create
    set_form_object

    ## Assign new SshKey to @user
    @ssh_key_form.submit(ssh_key_params.merge(user: User.current))

    if @ssh_key_form.save
      flash[:notice] = t('.notice')
      # Call service objects to perform other actions
      call_service_objects
      # Reset form object
      set_form_object
    end
  end


  def destroy
    if request.delete?
      if @ssh_key.destroy
        flash[:notice] = t('.notice')
        # Call service objects to perform other actions
        call_service_objects
        # Reset form object
        set_form_object
      end
    end
  end


  private


    def set_form_object
      @ssh_key = SshPublicKey.new
      @ssh_key_form = PublicKeyCreationForm.new(@ssh_key)
    end


    def ssh_key_params
      params.require(:ssh_public_key).permit(:title, :key)
    end


    def find_user_ssh_keys
      @ssh_keys = User.current.ssh_public_keys
    end


    def find_ssh_key
      @ssh_key = User.current.ssh_public_keys.find_by_id(params[:id])
    end


    def call_service_objects
      case self.action_name
      when 'create'
        result = @ssh_key.add_to_authorized_keys!
      when 'destroy'
        result = @ssh_key.remove_from_authorized_keys!
      end
      flash[:alert] = result.errors if !result.success?
    end

end
