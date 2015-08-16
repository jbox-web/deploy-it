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

end
