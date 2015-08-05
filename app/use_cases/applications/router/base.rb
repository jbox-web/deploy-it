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

module Applications
  module Router
    module Base

      def router_server
        application.find_server_with_role(:lb)
      end


      def execute_if_exists(&block)
        if router_server.nil?
          error_message(t('errors.unavailable_router'))
        else
          yield
        end
      end


      def catch_errors(&block)
        begin
          router_server.recreate_inventory_file!
          yield
        rescue => e
          error_message(treat_exception(e))
          log_exception(e)
        end
      end


      def treat_exception(e)
        case e
        when DeployIt::Error::IOError
          t('errors.io_error')
        when DeployIt::Error::InvalidRouterUpdate
          t('errors.invalid_router_update')
        when DeployIt::Error::UnreachableRouter
          t('errors.unreachable_router')
        when DeployIt::Error::RouterUpdateFailed
          t('errors.router_update_failed')
        else
          t('errors.unknown_error')
        end
      end

    end
  end
end
