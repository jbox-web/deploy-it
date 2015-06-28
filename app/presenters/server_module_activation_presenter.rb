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

class ServerModuleActivationPresenter < SimpleDelegator

  attr_reader :server
  attr_reader :role


  def initialize(server, template, role)
    super(template)
    @server = server
    @role   = role
  end


  def module_link
    link_to label_with_stacked_icon('', icons, base: 'circle', class: 'fa-2x'),
            link_url,
            title:  role.name,
            method: :patch,
            remote: true
  end


  def module_status
    if server.has_role?(role.type)
      label_with_icon t('label.server_role.enabled', role: role), 'fa-check', fixed: true, color: '#5cb85c'
    else
      label_with_icon t('label.server_role.disabled', role: role), '', fixed: true
    end
  end


  private


    def link_url
      if server.has_role?(role.type)
        disable_role_admin_platform_server_path(server.platform, server, role: role.type)
      else
        enable_role_admin_platform_server_path(server.platform, server, role: role.type)
      end
    end


    def icons
      default_css.push(role.to_icon)
    end


    def default_css
      %w[ fa-inverse ]
    end

end
