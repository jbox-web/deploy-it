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

class ServerPresenter < SimpleDelegator

  attr_reader :server


  def initialize(server, template)
    super(template)
    @server = server
  end


  def edit_link
    link_to server.host_name, edit_admin_platform_server_path(server.platform, server)
  end


  def server_roles
    render_server_roles
  end


  private


    def render_server_roles
      html_list do
        content = ''
        server.roles.by_role.each do |role|
          content << render_role(role)
        end
        content.html_safe
      end
    end


    def render_role(role)
      content_tag(:li, id: "server-#{server.id}-#{role.to_s}", class: "connexion-status", data: { "refresh-url" => status_admin_platform_server_path(server.platform, server, role: role.to_s) }) do
        render_role_name(role) + render_default_role(role) + render_service_status(has_errors: nil)
      end
    end

end
