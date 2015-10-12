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
    module ApplicationCommon

      private


        def execute_action(application, params = {}, &block)
          result = yield application
          if result.success?
            application.run_async!('update_files!')
            context.render_success(locals: { application: application })
          else
            context.render_failed(locals: { application: application }, message: result.message_on_errors)
          end
        end


        def update_application(application, params = {}, &block)
          if application.update(params)
            yield application if block_given?
            context.render_success(locals: { application: application })
          else
            context.render_failed(locals: { application: application })
          end
        end


        def update_boolean_field_if_allowed(condition, application, field, params)
          if condition
            value, message = values_for_boolean(params[:checked])
            application.update_attribute(field, value)
            context.render_success(locals: { application: application }, message: message)
          else
            context.render_failed(locals: { application: application })
          end
        end


        def values_for_boolean(param)
          [extract_boolean_value(param), boolean_message(param)]
        end


        def extract_boolean_value(param)
          param == 'true' ? true : false
        end


        def boolean_message(param)
          param == 'true' ? t('.notice.enabled') : t('.notice.disabled')
        end


        def disable_ssl(application)
          application.update_attribute(:use_ssl, false)
        end


        def disable_credentials(application)
          application.update_attribute(:use_credentials, false)
        end

    end
  end
end
