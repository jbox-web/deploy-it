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


      def render_message(message, type, locals = {})
        flash_type = type == :success ? :notice : :alert
        flash[flash_type] = message if render_flash_message?
        render_dci_response(template: get_template, locals: locals, type: type)
      end


      private


        def get_dci_role
          self.class.get_dci_role
        end


        def call_dci_role(method, *args)
          opts = get_dci_data
          args << opts unless opts.nil?
          get_dci_role.constantize.new(self).send(method, *args)
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
          action
        end


        def destroy?
          action_name == 'destroy'
        end


        def success_create?(type)
          action_name == 'create' && type == :success
        end


        def render_dci_response(template: action_name, locals: {}, type:, &block)
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
