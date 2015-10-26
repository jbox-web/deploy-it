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

module DCI
  module Roles
    class AccountManager < Base

      def update_account(user, params = {})
        if user.update(params)
          # Locales may have changed, reset them before redirect
          context.reload_user_locales
          context.render_success(locals: { user: user })
        end
      end


      def reset_api_key(user)
        user.api_token = DeployIt::Utils::Crypto.generate_secret(42)
        user.save!
        context.render_success(locals: { user: user })
      end


      def create_ssh_key(user, params = {})
        ssh_key = SshPublicKey.new(params.merge(user_id: user.id))
        if ssh_key.save
          task = ssh_key.add_to_authorized_keys!
          context.render_success(locals: { user: user }, errors: task.errors)
        else
          context.render_failed(locals: { user: user, ssh_key: ssh_key })
        end
      end


      def delete_ssh_key(user, ssh_key, params = {})
        if ssh_key.destroy
          task = ssh_key.remove_from_authorized_keys!
          context.render_success(locals: { user: user }, errors: task.errors)
        else
          context.render_failed(locals: { user: user })
        end
      end

    end
  end
end
