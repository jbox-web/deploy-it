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

module NavigationSections

  USER_CONTROLLERS        = %w(MyController PublicKeysController RegistrationsController)
  APPLICATION_CONTROLLERS = {
    'ApplicationsController'       => %w(index new),
    'ApplicationsConfigController' => %w(),
    'MembersController'            => %w()
  }


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
    controller.class.name == 'ApplicationsController' && (action_name == 'index' || action_name == 'new')
  end


  def show_application_section?
    APPLICATION_CONTROLLERS.keys.include?(controller.class.name) && !APPLICATION_CONTROLLERS[controller.class.name].include?(action_name)
  end


  def credential_section?
    controller.class.name == 'CredentialsController'
  end

end
