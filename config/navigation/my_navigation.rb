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

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |menu|
    menu.dom_id = 'side-menu'
    menu.dom_class = 'nav'
    menu.item :my_profile,      { icon: icon_for_entry('fa-user'), text: t('text.my_account') }, my_account_path
    menu.item :change_password, { icon: icon_for_entry('fa-lock'), text: t('text.change_password') }, edit_user_registration_path
    menu.item :ssh_keys,        { icon: icon_for_entry('fa-key'),  text: t('text.my_ssh_keys') }, public_keys_path
  end
end
