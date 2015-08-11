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

module Contextable
  extend ActiveSupport::Concern


  def render_success(message: t('.notice'), template: get_template, locals: {})
    locals = locals.merge(saved: true)
    render_message(message, :notice, template, locals)
  end


  def render_failed(message: t('.error'), template: get_template, locals: {})
    locals = locals.merge(saved: false)
    render_message(message, :alert, template, locals)
  end


  def render_message(message, type, template, locals = {})
    flash[type] = message
    render_ajax_response(template: template, locals: locals)
  end


  private


    def get_template(action: action_name)
      action
    end

end
