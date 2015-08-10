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
      topbar_right_menu do |menu|
        menu.item :applications, get_model_name_for('Application'), applications_path
        menu.item :admin,        t('.admin'), admin_root_path if User.current.admin?

        menu.item :logged, User.current.email, my_account_path, highlights_on: %r(/my), link_html: { data: { toggle: 'dropdown' } }, class: 'dropdown' do |sub_menu|
          sub_menu.auto_highlight = false
          sub_menu.item :my_account, t('.my_account'), my_account_path, highlights_on: %r(/my)
          sub_menu.item :help,       t('.help'), help_path, highlights_on: :subpath
          sub_menu.item :divider, '', '', class: :divider, role: :presentation
          sub_menu.item :logout,     t('.logout'), destroy_user_session_path, method: :delete
        end
      end
    end


    def not_logged_user_menu
      topbar_right_menu do |menu|
        menu.item :login,  t('.login'), new_user_session_path
        # menu.item :signup, t('.signup'), new_user_registration_path
      end
    end

end
