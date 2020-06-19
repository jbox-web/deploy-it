# frozen_string_literal: true
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
    module Base
      extend self

      def render_success(message: t('.notice'), locals: {}, errors: [])
        locals = locals.merge(saved: true)
        render_message(message: message, type: :success, locals: locals, errors: errors)
      end


      def render_failed(message: t('.error'), locals: {}, errors: [])
        locals = locals.merge(saved: false)
        render_message(message: message, type: :error, locals: locals, errors: errors)
      end


      private


        def logger
          DeployIt.console_logger
        end

    end
  end
end
