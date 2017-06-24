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

module BaseController
  module Errors
    extend ActiveSupport::Concern

    def render_403(exception = nil)
      @application = nil
      render_4xx_error(t('errors.not_authorized'), 403)
      return false
    end


    def render_404(exception = nil)
      render_4xx_error(t('errors.file_not_found'), 404)
      return false
    end


    private


      # Renders an error response
      def render_4xx_error(message, status)
        @message    = message
        @status     = status
        @page_title = "#{t('text.error')} #{@status}"

        respond_to do |format|
          format.html { render template: 'common/error', layout: error_layout, status: @status }
          format.any { head @status }
        end
      end


      def error_layout
        request.xhr? ? false : 'application'
      end

  end
end
