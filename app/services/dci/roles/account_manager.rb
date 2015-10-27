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
        locals = { user: user }
        ssh_key.save ? context.render_success(locals: locals) : context.render_failed(locals: locals.merge(ssh_key: ssh_key))
      end


      def delete_ssh_key(user, ssh_key, params = {})
        locals = { locals: { user: user } }
        ssh_key.destroy ? context.render_success(locals) : context.render_failed(locals)
      end


      def create_user(params = {})
        user_form = UserCreationForm.new(User.new).submit(params)
        if user_form.save
          send_email(:welcome, user_form.user, user_form.created_password) if user_form.send_email?
          context.render_success
        else
          context.render_failed(locals: { user: user_form })
        end
      end


      def update_user(user, params = {}, &block)
        if user.update(params)
          yield if block_given?
          context.render_success
        else
          context.render_failed(locals: { user: user })
        end
      end


      def delete_user(user)
        user.destroy ? context.render_success : context.render_failed
      end


      def change_password(user, params = {}, &block)
        password_form = AdminPasswordForm.new(user).submit(params)
        if password_form.save
          yield if block_given?
          send_email(:password_changed, user, password_form.new_password) if password_form.send_email?
          context.render_success
        else
          context.render_failed(locals: { password_form: password_form })
        end
      end


      private


        def send_email(method, user, password)
          RegistrationMailer.send(method, user, password).deliver_now
        end

    end
  end
end
