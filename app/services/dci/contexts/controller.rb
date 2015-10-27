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
  module Contexts
    module Controller
      extend ActiveSupport::Concern

      include Base

      included do
        class_attribute :render_flash_message
        self.render_flash_message = true

        class << self

          def set_dci_role(role)
            @dci_role = role
          end

          def get_dci_role
            @dci_role
          end

        end
      end


      def render_message(message:, type:, locals: {}, errors: [])
        flash_type = type == :success ? :notice : :alert
        flash[flash_type] = message if render_flash_message?
        flash[:alert] = errors if render_flash_message? && errors.any?
        render_dci_response(template: get_template, type: type, locals: locals)
      end


      private


        def get_dci_role
          self.class.get_dci_role
        end


        def call_dci_role(method, *args, &block)
          opts = get_dci_data
          args << opts unless opts.nil?
          get_dci_role.constantize.new(self).send(method, *args, &block)
        end


        def set_dci_data(dci_data)
          @dci_data = dci_data
        end


        def get_dci_data
          return @dci_data if @dci_data.nil?

          rescue_from_error = @dci_data.delete(:rescue) { true }
          strong_params     = @dci_data.delete(:strong_params) { true }

          if strong_params
            if rescue_from_error
              params.require(@dci_data.keys.first).permit(@dci_data.values.first) rescue {}
            else
              params.require(@dci_data.keys.first).permit(@dci_data.values.first)
            end
          else
            @dci_data
          end
        end


        def get_template(action: action_name)
          return action if request.xhr?
          case action
          when 'new', 'create'
            'new'
          when 'edit', 'update'
            'edit'
          else
            action
          end
        end


        def create_action?
          action_name == 'create'
        end


        def update_action?
          action_name == 'update'
        end


        def destroy_action?
          action_name == 'destroy'
        end


        def change_password_action?
          action_name == 'change_password'
        end


        def success_action?(type)
          type == :success
        end


        def success_create?(type)
          create_action? && success_action?(type)
        end


        def success_update?(type)
          update_action? && success_action?(type)
        end


        def success_password_update?(type)
          change_password_action? && success_action?(type)
        end


        def render_dci_response(template:, type:, locals: {}, &block)
          if block_given?
            yield
          else
            respond_to do |format|
              format.html { render template, locals: locals }
              format.js   { render ajax_template_path(template), locals: locals }
            end
          end
        end

    end
  end
end
