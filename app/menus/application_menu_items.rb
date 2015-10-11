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

class ApplicationMenuItems < SimpleDelegator

  attr_reader :application
  attr_reader :options


  def initialize(application, view, options = {})
    super(view)
    @application = application
    @options     = options
  end


  def item_app_infos
    create_hash t('.informations'), 'fa-info-circle', infos_application_path(application)
  end


  def item_app_repositories
    create_hash t('.code'), 'fa-code', repositories_application_path(application)
  end


  def item_app_containers
    create_hash get_model_name_for('Container'), 'fa-rocket', containers_application_path(application)
  end


  def item_app_settings
    create_hash get_model_name_for('Settings'), 'fa-sliders', settings_application_path(application), permission_option(:edit_application)
  end


  def item_app_members
    create_hash get_model_name_for('Member'), 'fa-users', application_members_path(application), permission_option(:manage_members)
  end


  def item_app_repository
    create_hash get_model_name_for('Repository'), 'fa-git', repository_application_path(application), permission_option(:edit_application)
  end


  def item_app_domain_names
    create_hash get_model_name_for('DomainName'), 'fa-random', domain_names_application_path(application), permission_option(:edit_application)
  end


  def item_app_env_vars
    create_hash get_model_name_for('EnvVar'), 'fa-list-ul', env_vars_application_path(application), permission_option(:edit_application)
  end


  def item_app_mount_points
    create_hash get_model_name_for('MountPoint'), 'fa-download', mount_points_application_path(application), permission_option(:edit_application)
  end


  def item_app_credentials
    create_hash get_model_name_for('ApplicationCredential'), 'fa-eye', credentials_application_path(application), permission_option(:edit_application)
  end


  def item_app_addons
    create_hash get_model_name_for('Addon'), 'fa-cube', addons_application_path(application), permission_option(:edit_application)
  end


  def item_app_ssl_certificate
    create_hash get_model_name_for('SslCertificate'), 'fa-shield', ssl_certificate_application_path(application), permission_option(:edit_application)
  end


  def item_app_database
    create_hash get_model_name_for('ApplicationDatabase'), 'fa-database', database_application_path(application), permission_option(:edit_application)
  end


  def create_hash(label, icon, url, opts = {}, id = caller[2][/`.*'/][1..-2])
    id = id.gsub('item_', '')
    opts = opts.merge(options)
    { id: id, label: label_with_icon(label, icon), url: url, opts: opts }
  end


  def permission_option(permission)
    { if: -> { can?(permission, application) } }
  end


  def render_links
    self.methods.select { |m| m.to_s.starts_with?('item_') }.collect { |m| self.send(m) }
  end

end
