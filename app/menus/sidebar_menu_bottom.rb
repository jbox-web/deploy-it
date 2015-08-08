class SidebarMenuBottom < BaseMenu

  def render
    menu = ''
    menu += render_menu(&credential_menu_items) if application_section? || credential_section?
    menu.html_safe
  end


  private


    def credential_menu_items
      nav_menu do |menu|
        menu.item :new_credentials, label_with_icon(t('label.repository_credential.new'), 'fa-plus'), new_credential_path if can?(:create_credential, nil, global: true)
        RepositoryCredential.all.each do |credential|
          menu.item :credential, label_with_icon(credential.name, 'octicon octicon-key'), edit_credential_path(credential)
        end if can?(:edit_credential, nil, global: true)
      end
    end

end
