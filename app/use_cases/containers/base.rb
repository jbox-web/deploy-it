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

module Containers
  module Base

    def execute_if_exists(&block)
      if container.docker_id
        yield
      else
        error_message(I18n.t('use_cases.container.errors.not_exists'))
      end
    end


    def catch_errors(opts = {}, &block)
      update_route = opts.delete(:update_route){ false }
      begin
        yield
      rescue => e
        log_exception(e)
        error_message(e.message)
      else
        container.application.update_lb_route! if update_route
      end
    end

  end
end
