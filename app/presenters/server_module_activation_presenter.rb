# frozen_string_literal: true
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
    if module_enabled?
      label_with_icon t('.enabled', role: role), 'fa-check', fixed: true, color: '#5cb85c'
    else
      label_with_icon t('.disabled', role: role), '', fixed: true
    end
  end


  def module_css
    module_enabled? ? default_css : default_css.push('disabled')
  end


  private


    def link_url
      if module_enabled?
        disable_role_admin_platform_server_path(server.platform, server, role: role.type)
      else
        enable_role_admin_platform_server_path(server.platform, server, role: role.type)
      end
    end


    def module_enabled?
      server.has_role?(role.type)
    end


    def icons
      default_icon_css.push(role.to_icon)
    end


    def default_icon_css
      ['fa-inverse'].clone
    end


    def default_css
      ['server-module'].clone
    end

end
