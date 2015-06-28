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

class ContainerPresenter < SimpleDelegator

  attr_reader :container


  def initialize(container, template)
    super(template)
    @container = container
  end


  def docker_name
    container.docker_name rescue "Cannot find container"
  end


  def container_actions
    content_tag(:span, class: 'pull-right') do
      case container.state
      when :running
        links_for_running_container
      when :paused
        links_for_paused_container
      when :stopped
        links_for_stopped_container
      end
    end
  end


  def container_infos
    uptime = distance_of_time_in_words(DateTime.now, container.uptime) rescue 'Not running'
    html_list(class: 'container-infos') do
      add_item(t('label.container.state'), container_state_tag) +
      add_item(t('label.container.docker_id'), container.docker_id[0..12]) +
      add_item(t('label.container.uptime'), uptime) +
      add_item(t('label.container.backend_url'), container.backend_url) +
      add_item(t('label.container.current_revision'), container.current_revision) +
      add_item(t('label.container.current_server'), container.docker_server.to_s)
    end
  end


  private


    def add_item(label, item)
      content_tag(:li) do
        content_tag(:span, label) + content_tag(:span, item, class: 'pull-right')
      end
    end


    def container_state_tag
      case container.state
      when :running
        label   = t('label.container.running')
        method  = :label_with_success_tag
        icon    = :label_with_icon_check
      when :paused
        label   = t('label.container.paused')
        method  = :label_with_warning_tag
        icon    = :label_with_icon_warning
      when :stopped
        label   = t('label.container.stopped')
        method  = :label_with_danger_tag
        icon    = :label_with_icon_warning
      end

      self.send(method) do
        self.send(icon, "#{label}")
      end
    end


    def links_for_running_container
      manage_link('pause', 'fa-pause') +
      manage_link('stop', 'fa-power-off') +
      manage_link('restart', 'fa-refresh') +
      info_link
    end


    def links_for_paused_container
      manage_link('unpause', 'fa-play')
    end


    def links_for_stopped_container
      manage_link('start', 'fa-power-off')
    end


    def manage_link(action, icon)
      link_to_icon(icon, manage_application_container_path(container.application, container, deploy_action: action), link_options(action), icon_options)
    end


    def info_link
      link_to_icon('fa-info-circle', infos_application_container_path(container.application, container), info_options, icon_options)
    end


    def info_options
      { 'data-title' => t('label.container.docker_infos'), 'data-toggle' => 'lightbox', 'data-width' => '1000' }
    end


    def link_options(action)
      { title: t("label.container.#{action}"), method: :post, remote: true }
    end


    def icon_options
      { fixed: true }
    end

end
