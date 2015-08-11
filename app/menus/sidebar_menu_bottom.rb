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

class SidebarMenuBottom < BaseMenu

  def render
    menu = ''
    menu += render_menu(&credential_menu_items) if application_section? || credential_section?
    menu.html_safe
  end


  private


    def credential_menu_items
      sidebar_menu do |menu|
        menu.item :new_credentials, label_with_icon(t('.new_credentials'), 'fa-plus'), new_credential_path if can?(:create_credential, nil, global: true)
        RepositoryCredential.all.each do |credential|
          menu.item :credential, label_with_icon(credential.name, 'octicon octicon-key'), edit_credential_path(credential)
        end if can?(:edit_credential, nil, global: true)
      end
    end

end
