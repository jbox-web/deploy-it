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

class BaseMenu < SimpleDelegator

  USER_CONTROLLERS = [ 'MyController', 'PublicKeysController', 'RegistrationsController' ]


  def initialize(view)
    super(view)
  end


  def current_menu_name
    if admin_section?
      t('.admin')
    elsif profile_section?
      t('.my_account')
    elsif welcome_section?
      t('.help')
    else
      get_model_name_for('Application')
    end
  end


  private


    def sidebar_menu(&block)
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        yield menu
      end
    end


    def topbar_right_menu(&block)
      proc do |menu|
        menu.dom_class = 'nav navbar-nav navbar-right'
        yield menu
      end
    end


    def render_menu(opts = {}, &block)
      opts = { renderer: :bootstrap3, expand_all: true, remove_navigation_class: true, skip_if_empty: true }.merge(opts)
      # Call simple-navigation rendering method
      filter_menu(render_navigation(opts, &block))
    end


    def filter_menu(menu)
      menu.empty? ? '' : menu
    end


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

end
