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

class ApplicationToolbarPresenter < SimpleDelegator

  attr_reader :application


  def initialize(application, template)
    super(template)
    @application = application
  end


  def toolbar
    render_toolbar
  end


  private


    def render_toolbar
      html_list(class: 'list-inline text-center') do
        case application.state
        when :running
          links_for_running_application
        when :paused
          links_for_paused_application
        when :stopped
          links_for_stopped_application
        when :undeployed
          links_for_undeployed_application
        end
      end
    end


    def links_for_running_application
      add_item(manage_link('pause', 'fa-pause')) +
      add_item(manage_link('stop', 'fa-power-off')) +
      add_item(manage_link('restart', 'fa-refresh')) +
      add_item(build_link('rebuild', 'fa-wrench'))
    end


    def links_for_paused_application
      add_item(manage_link('unpause', 'fa-play'))
    end


    def links_for_stopped_application
      add_item(manage_link('start', 'fa-power-off')) +
      add_item(build_link('rebuild', 'fa-wrench'))
    end


    def links_for_undeployed_application
      add_item(build_link('rebuild', 'fa-wrench'))
    end


    def manage_link(action, icon)
      label = t(".app_#{action}")
      link_to label_with_icon(label, icon), manage_application_path(application, deploy_action: action), title: label, remote: true, method: :post
    end


    def build_link(action, icon)
      label = t(".app_#{action}")
      link_to label_with_icon(label, icon), build_application_path(application), title: label, remote: true, method: :post
    end


    def add_item(item)
      content_tag(:li, item)
    end

end
