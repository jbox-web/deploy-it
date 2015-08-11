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

module BaseController::Ajax
  extend ActiveSupport::Concern

  def render_ajax_redirect(url)
    respond_to do |format|
      format.js { render js: "window.location = #{url.to_json};" }
    end
  end


  def render_ajax_response(template: action_name, locals: {})
    respond_to do |format|
      format.js { render "#{get_controller_name}/ajax/#{template}", locals: locals }
    end
  end


  def get_controller_name
    self.class.name.gsub('Controller', '').underscore
  end

end
