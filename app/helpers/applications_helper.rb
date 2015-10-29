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

module ApplicationsHelper

  def render_application_select_box(opts = {})
    content_tag(:div, build_application_select_box, opts)
  end


  def render_active_containers(application)
    css = application.containers.length == 0 ? 'danger' : 'success'
    css_class = "label label-#{css}"
    content_tag(:span, application.containers.length, class: css_class)
  end


  def render_env_var(env_var)
    value = env_var.masked? ? '*******' : env_var.value
    "#{env_var.key} : #{value}"
  end


  def render_credential(cred)
    "#{cred.login} : *******"
  end


  def render_group_member_form(opts = {})
    render_member_form('group', opts)
  end


  def render_user_member_form(opts = {})
    render_member_form('user', opts)
  end


  def render_enroblable(enrolable)
    render_member(enrolable.enrolable)
  end


  def render_step_counter(application)
    counter = "#{application.current_index + 1}/#{application.total_steps}"
    "#{t('.current_step')} : #{counter}"
  end


  def build_application_select_box
     select_tag "navigation-selector", options_for_select(application_select_box_content, application_select_box_selected),
                                       onchange: "if (this.value != '') { window.location = this.value; }",
                                       class: "select2"
  end


  def available_docker_images
    DockerImage.all.collect { |p| [p, p] }
  end


  def available_buildpacks
    Buildpack.all.collect { |p| [p, p.url] }
  end


  def available_database_types
    ApplicationDatabase.available_database_types.collect { |p| [p, p] }
  end


  def available_database_servers
    Server.all.collect{ |s| [s.to_s, s.id] }
  end


  def max_instances_available
    Application.max_instances_number.collect { |p| [p, p] }
  end


  def max_memory_available
    Application.max_memory_available.collect { |p| ["#{p}M", p] }
  end


  def addons_available
    Application.addons_available.collect { |p| [p.to_s.capitalize, p.to_s] }
  end


  def render_memory_icon(memory)
    DeployIt::Theme::MEMORY_ICONS_MAPPING[memory]
  end


  def slider_options_for_max_memory(application)
    slider_options(list: Application.max_memory_available, value: application.max_memory, step: 128)
  end


  def slider_options_for_instance_number(application)
    slider_options(list: Application.max_instances_number, value: application.instance_number, enabled: application.instance_number_editable?)
  end


  def slider_options(list:, value:, step: 1, enabled: true)
    { slider_min: list.min, slider_max: list.max, slider_step: step, slider_value: value, slider_enabled: enabled }
  end


  ### PRIVATE ###


  def render_member_form(type, opts = {})
    label_col = opts.delete(:label_col){ 'col-sm-2' }
    control_col = opts.delete(:control_col){ 'col-sm-4' }
    string = ''.html_safe
    string << content_tag(:div, class: 'form-group') do
      label_tag("member_#{type}_ids", get_model_name_for(type.capitalize), class: "control-label #{label_col}") +
      content_tag(:div, class: control_col) do
        render_member_checkbox(type)
      end
    end
    string
  end


  def render_member_checkbox(type)
    string = ''.html_safe
    send("render_#{type}s_for_new_members").each do |member|
      string << content_tag(:div, class: 'checkbox') do
        label_tag("member_#{type}_ids_#{member.id}") do
          check_box_tag("member[#{type}_ids][]", member.id, false, id: "member_#{type}_ids_#{member.id}") +
          render_member(member)
        end
      end
    end
    string
  end


  def render_users_for_new_members
    User.all - @application.calculated_members
  end


  def render_groups_for_new_members
    Group.all - @application.groups
  end


  def render_member(member)
    icon = member.is_a?(User) ? 'fa-user' : 'fa-users'
    label_with_icon(member.to_s, icon, fixed: true)
  end


  def application_select_box_content
    grouped_options = []
    grouped_options << [ t('helpers.select.prompt'), '' ]
    Application.visible.includes(:stage).sorted_by_fullname.each do |application|
      grouped_options << [ application.fullname, infos_application_path(application) ]
    end
    grouped_options
  end


  def application_select_box_selected
    selected =
      begin
        infos_application_path(@application)
      rescue => e
        @application = nil
        ''
      end
    selected
  end


  def render_addon_with_icon(addon_name, addon_type)
    image_name =
      case addon_type
      when 'redis'
        'redis.svg'
      when 'memcached'
        'memcached.png'
      end
    label_with_image(addon_name, image_name)
  end

end
