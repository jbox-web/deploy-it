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
          task = add_ssh_key_to_file(ssh_key)
          context.render_success(locals: { user: user }, errors: task.errors)
        else
          context.render_failed(locals: { user: user, ssh_key: ssh_key })
        end
      end


      def delete_ssh_key(user, ssh_key, params = {})
        if ssh_key.destroy
          task = remove_ssh_key_from_file(ssh_key)
          context.render_success(locals: { user: user }, errors: task.errors)
        else
          context.render_failed(locals: { user: user })
        end
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
          errors = toggle_ssh_keys(user)
          context.render_success(errors: errors)
        else
          context.render_failed(locals: { user: user })
        end
      end


      def delete_user(user)
        if user.destroy
          errors = execute_post_action(user, :remove_ssh_key_from_file)
          context.render_success(errors: errors)
        else
          context.render_failed
        end
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


        def toggle_ssh_keys(user)
          user.disabled? ? execute_post_action(user, :remove_ssh_key_from_file) : execute_post_action(user, :add_ssh_key_to_file)
        end


        def remove_ssh_key_from_file(ssh_key)
          ssh_key.remove_from_authorized_keys!
        end


        def add_ssh_key_to_file(ssh_key)
          ssh_key.add_to_authorized_keys!
        end


        def execute_post_action(user, method)
          errors = []
          user.ssh_public_keys.each do |ssh_key|
            task = self.send(method, ssh_key)
            errors += task.errors if !task.success?
          end
          errors
        end


        def send_email(method, user, password)
          RegistrationMailer.send(method, user, password).deliver_now
        end

    end
  end
end
