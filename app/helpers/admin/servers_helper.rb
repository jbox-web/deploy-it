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

module Admin::ServersHelper

  def service_status(role, has_errors:)
    render_role_name(role) + render_default_role(role) + render_service_status(has_errors: has_errors)
  end


  def render_role_name(role)
    content_tag(:span) do
      label_with_icon('', role.to_icon, title: role.humanize)
    end
  end


  def render_default_role(role)
    if role.default_server?
      title = t('label.server_role.default')
      color = '#5cb85c'
    else
      title = ''
      color = '#000'
    end

    content_tag(:span) do
      icon('fa-check-circle-o', fixed: true, title: title, color: color)
    end
  end


  def render_service_status(has_errors: nil)
    if has_errors.nil?
      title = 'Service status'
      color = ''
    elsif has_errors
      title = 'Service DOWN'
      color = '#d9534f'
    else
      title = 'Service OK'
      color = '#5cb85c'
    end

    content_tag(:span) do
      icon('fa-heartbeat', fixed: true, color: color, title: title)
    end
  end

end
