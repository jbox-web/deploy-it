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

module ActsAs
  module LogServer
    extend ActiveSupport::Concern

    def role_logger
      get_role_module('log')
    end


    def logger_host
      role_logger.alternative_host
    end


    def logger_port
      role_logger.port
    end


    def logger_url
      if !logger_host.empty?
        "#{logger_host}:#{logger_port}"
      else
        "#{ip_address}:#{logger_port}"
      end
    end

  end
end
