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

module NavigationHelper

  # Here we create zones for menus :
  # We have 3 zones :
  # 1. the header menu
  # 2. the top menu of the left sidebar
  # 3. the bottom menu of the left sidebar


  def render_application_select_box
    if User.current.logged? && (application_section? || credential_section?)
      content_tag(:div, build_application_select_box, class: "navbar-form")
    else
      ''
    end
  end


  def topbar_menu_items
    menu =
      render_menu(&header_menu_items)
  end


  def sidebar_menu_top_items
    menu =
      render_menu(&admin_menu_items) +
      render_menu(&user_account_menu_items) +
      render_menu(&welcome_menu_items) +
      render_application_select_box +
      render_menu(&application_menu_items)
    menu.html_safe
  end


  def sidebar_menu_bottom_items
    menu =
      render_menu(&user_profile_menu_items) +
      render_menu(&credential_menu_items)
    menu.html_safe
  end


  def current_menu_name
    if admin_section?
      t('label.admin')
    elsif profile_section?
      t('label.my.account')
    elsif welcome_section?
      t('label.help')
    else
      t('label.application.plural')
    end
  end


  def render_page_content(opts = {})
    sidebar = render 'layouts/sidebar'
    if sidebar.strip != ''
      sidebar + content_tag(:div, opts) do
        render 'layouts/page'
      end
    else
      content_tag(:div, class: 'col-md-12 col-sm-12') do
        render 'layouts/page'
      end
    end
  end


  private


  # Here we create all menus we need with simple-navigation gem.
  # Each menu includes its own condition of display depending on the current user and/or the current controller.
  # This generate HTML list with Bootstrap css class.


  USER_CONTROLLERS = [ 'MyController', 'PublicKeysController', 'RegistrationsController' ]


  def welcome_section?
    !admin_section? && !dashboard_section? && !profile_section?
  end


  def admin_section?
    controller.class.name.split("::").first == 'Admin'
  end


  def dashboard_section?
    !USER_CONTROLLERS.include?(controller.class.name) && controller.class.name != 'WelcomeController'
  end


  def profile_section?
    USER_CONTROLLERS.include?(controller.class.name)
  end


  def application_section?
    controller.class.name == 'ApplicationsController'
  end


  def credential_section?
    controller.class.name == 'CredentialsController'
  end


  def admin_menu_items
    if User.current.logged? && User.current.admin? && admin_section?
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :users,             label_with_icon(t('label.user.plural'), 'fa-user'), admin_users_path, highlights_on: :subpath
        menu.item :groups,            label_with_icon(t('label.group.plural'), 'fa-users'), admin_groups_path, highlights_on: :subpath
        menu.item :roles,             label_with_icon(t('label.role.plural'), 'fa-database'), admin_roles_path, highlights_on: :subpath
        menu.item :application_types, label_with_icon(t('label.application_type.plural'), 'fa-desktop'), admin_application_types_path, highlights_on: :subpath
        menu.item :platforms,         label_with_icon(t('label.platform.plural'), 'fa-sitemap'), admin_platforms_path, highlights_on: :subpath
        menu.item :docker_images,     label_with_icon(t('label.docker_image.plural'), 'fa-cubes'), admin_docker_images_path, highlights_on: :subpath
        menu.item :buildpacks,        label_with_icon(t('label.buildpack.plural'), 'fa-rocket'), admin_buildpacks_path, highlights_on: :subpath
        menu.item :reserved_names,    label_with_icon(t('label.reserved_name.plural'), 'fa-shield'), admin_reserved_names_path, highlights_on: :subpath
        menu.item :applications,      label_with_icon(t('label.application.plural'), 'fa-desktop'), admin_applications_path, highlights_on: :subpath
      end
    end
  end


  def application_menu_items
    if User.current.logged? && (application_section? || credential_section?)
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :new_application, label_with_icon(t('label.application.new'), 'fa-plus'), new_application_path if can?(:create_application, nil, global: true)
        Application.visible.includes(:stage).all.sort_by(&:fullname).each do |application|
          menu.item "application_#{application.id}", label_with_icon(application.fullname, 'fa-desktop'), application_path(application)
        end
      end
    end
  end


  def credential_menu_items
    if User.current.logged? && (application_section? || credential_section?)
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :new_credentials, label_with_icon(t('label.repository_credential.new'), 'fa-plus'), new_credential_path if can?(:create_credential, nil, global: true)
        RepositoryCredential.all.each do |credential|
          menu.item :credential, label_with_icon(credential.name, 'octicon octicon-key'), edit_credential_path(credential)
        end if can?(:edit_credential, nil, global: true)
      end
    end
  end


  def header_menu_items
    if User.current.logged?
      proc do |menu|
        menu.dom_class = 'nav navbar-nav navbar-right'
        menu.item :applications, t('label.application.plural'), applications_path
        menu.item :admin,        t('label.admin'), admin_root_path, highlights_on: :subpath if User.current.admin?

        menu.item :logged, User.current.email, my_account_path, link_html: { data: { toggle: 'dropdown' } }, class: 'dropdown' do |sub_menu|
          sub_menu.item :my_account, t('label.my.account'), my_account_path
          sub_menu.item :help,       t('label.help'), help_path
          sub_menu.item :divider, '', '', class: :divider, role: :presentation
          sub_menu.item :logout,     t('label.logout'), destroy_user_session_path, method: :delete
        end
      end
    else
      proc do |menu|
        menu.dom_class = 'nav navbar-nav navbar-right'
        menu.item :login,  t('label.login'), new_user_session_path
        # menu.item :signup, t('label.signup'), new_user_registration_path
      end
    end
  end


  def user_account_menu_items
    if User.current.logged? && profile_section?
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :my_profile,      label_with_icon(t('label.my.profile'), 'fa-user'), my_account_path
        menu.item :change_password, label_with_icon(t('label.user.change_password'), 'fa-lock'), edit_user_registration_path
        menu.item :ssh_keys,        label_with_icon(t('label.my.ssh_keys'), 'octicon octicon-key'), public_keys_path
      end
    end
  end


  def welcome_menu_items
    if User.current.logged? && welcome_section?
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :my_profile,   label_with_icon(t('label.my.profile'), 'fa-user'), my_account_path
        menu.item :applications, label_with_icon(t('label.application.plural'), 'fa-desktop'), applications_path
        menu.item :admin,        label_with_icon(t('label.admin'), 'fa-cog'), admin_root_path, if: proc { User.current.admin? }
        menu.item :help,         label_with_icon(t('label.help'), 'fa-book'), help_path
      end
    end
  end


  def user_profile_menu_items
    if User.current.logged? && controller.class.name == 'ProfilesController'
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        menu.item :user_profile, label_with_icon(t('label.user.profile'), 'fa-user'), '#'
      end
    end
  end


  def render_menu(opts = {}, &block)
    opts = { renderer: :bootstrap3, expand_all: true, remove_navigation_class: true }.merge(opts)
    # Call simple-navigation rendering method
    filter_menu(render_navigation(opts, &block))
  end


  def filter_menu(menu)
    if menu == '<ul></ul>' || menu == '<ul class=""></ul>'
      ''
    else
      menu
    end
  end

end
