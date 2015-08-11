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

module ApplicationCommon

  private


    def execute_action(application, params = {})
      result = yield application
      if result.success?
        application.run_async!('update_files!')
        render_success
      else
        render_failed(message: result.message_on_errors)
      end
    end


    def update_application(application, params = {})
      if application.update(params)
        yield application
        render_success
      else
        render_failed
      end
    end

end
