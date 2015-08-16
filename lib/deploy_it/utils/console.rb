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

module DeployIt
  module Utils
    module Console
      extend self

      def t(*args)
        I18n.t(*args)
      end


      def render_success(message: '', locals: {})
        console_log message unless message.empty?
      end


      def render_failed(message: '', locals: {})
        console_log message unless message.empty?
      end


      def console_log(errors)
        logger.empty_line

        if errors.is_a?(Array)
          errors.each do |error|
            logger.error error
          end
        else
          logger.error errors
        end

        logger.empty_line
      end


      def logger
        DeployIt.console_logger
      end

    end
  end
end
