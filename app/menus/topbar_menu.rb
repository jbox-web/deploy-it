class TopbarMenu < BaseMenu

  def render
    menu = ''
    if User.current.logged?
      menu += render_menu(&logged_user_menu)
    else
      menu += render_menu(&not_logged_user_menu)
    end
    menu.html_safe
  end


  private


    def logged_user_menu
      nav_bar_right do |menu|
        menu.item :applications, t('label.application.plural'), applications_path
        menu.item :admin,        t('label.admin'), admin_root_path if User.current.admin?

        menu.item :logged, User.current.email, my_account_path, highlights_on: %r(/my), link_html: { data: { toggle: 'dropdown' } }, class: 'dropdown' do |sub_menu|
          sub_menu.auto_highlight = false
          sub_menu.item :my_account, t('label.my.account'), my_account_path, highlights_on: %r(/my)
          sub_menu.item :help,       t('label.help'), help_path, highlights_on: :subpath
          sub_menu.item :divider, '', '', class: :divider, role: :presentation
          sub_menu.item :logout,     t('label.logout'), destroy_user_session_path, method: :delete
        end
      end
    end


    def not_logged_user_menu
      nav_bar_right do |menu|
        menu.item :login,  t('label.login'), new_user_session_path
        # menu.item :signup, t('label.signup'), new_user_registration_path
      end
    end

end
