class SidebarMenuTop < BaseMenu

  def render
    menu = ''
    menu += render_application_select_box if application_section? || credential_section?
    menu += render_menu(&admin_menu_items) if User.current.admin? && admin_section?
    menu += render_menu(&user_account_menu_items) if profile_section?
    menu += render_menu(&welcome_menu_items) if welcome_section?
    menu += render_menu(&application_menu_items) if application_section? || credential_section?
    menu.html_safe
  end


  private


    def admin_menu_items
      sidebar_menu do |menu|
        menu.item :users,             label_with_icon(t('label.user.plural'), 'fa-user'), admin_users_path
        menu.item :groups,            label_with_icon(t('label.group.plural'), 'fa-users'), admin_groups_path
        menu.item :roles,             label_with_icon(t('label.role.plural'), 'fa-database'), admin_roles_path
        menu.item :application_types, label_with_icon(t('label.application_type.plural'), 'fa-desktop'), admin_application_types_path
        menu.item :platforms,         label_with_icon(t('label.platform.plural'), 'fa-sitemap'), admin_platforms_path
        menu.item :docker_images,     label_with_icon(t('label.docker_image.plural'), 'fa-cubes'), admin_docker_images_path
        menu.item :buildpacks,        label_with_icon(t('label.buildpack.plural'), 'fa-rocket'), admin_buildpacks_path
        menu.item :reserved_names,    label_with_icon(t('label.reserved_name.plural'), 'fa-shield'), admin_reserved_names_path
        menu.item :applications,      label_with_icon(t('label.application.plural'), 'fa-desktop'), admin_applications_path
        menu.item :locks,             label_with_icon(t('label.lock.plural'), 'fa-lock'), admin_locks_path
        menu.item :settings,          label_with_icon(t('label.settings'), 'fa-info-circle'), admin_settings_path
        menu.item :sidekiq,           label_with_icon(t('label.sidekiq'), 'fa-gears'), sidekiq_web_path
      end
    end


    def user_account_menu_items
      sidebar_menu do |menu|
        menu.item :my_profile,      label_with_icon(t('label.my.profile'), 'fa-user'), my_account_path
        menu.item :change_password, label_with_icon(t('label.user.change_password'), 'fa-lock'), edit_user_registration_path
        menu.item :ssh_keys,        label_with_icon(t('label.my.ssh_keys'), 'octicon octicon-key'), public_keys_path
      end
    end


    def welcome_menu_items
      sidebar_menu do |menu|
        menu.item :my_profile,   label_with_icon(t('label.my.profile'), 'fa-user'), my_account_path
        menu.item :applications, label_with_icon(t('label.application.plural'), 'fa-desktop'), applications_path
        menu.item :admin,        label_with_icon(t('label.admin'), 'fa-cog'), admin_root_path if User.current.admin?
        menu.item :help,         label_with_icon(t('label.help'), 'fa-book'), help_path
      end
    end


    def application_menu_items
      sidebar_menu do |menu|
        menu.item :new_application, label_with_icon(t('label.application.new'), 'fa-plus'), new_application_path if can?(:create_application, nil, global: true)
        Application.visible.includes(:stage).all.sort_by(&:fullname).each do |application|
          menu.item "application_#{application.id}", label_with_icon(application.fullname, 'fa-desktop'), application_path(application)
        end
      end
    end


    def render_application_select_box
      content_tag(:div, build_application_select_box, class: "navbar-form")
    end

end
