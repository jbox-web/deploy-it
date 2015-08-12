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

    def execute_if_exists(object, &block)
      if !object.nil? && !object.empty?
        yield
      else
        error_message(message_on_nil_object)
      end
    end


    def catch_errors(container, opts = {}, &block)
      update_route = opts.delete(:update_route){ false }
      begin
        yield
      rescue => e
        log_exception(e)
        error_message(e.message)
      else
        container.application.touch
        container.application.update_lb_route! if update_route && container.stype == :web
      end
    end

  end
end
