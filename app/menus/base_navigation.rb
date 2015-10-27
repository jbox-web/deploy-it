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

class BaseNavigation < SimpleDelegator

  include NavigationSections

  attr_reader :prefix
  attr_reader :opts


  def initialize(view, opts = {})
    super(view)
    @prefix = opts.delete(:prefix) { nil }
  end


  def render(opts = {})
    return unless renderable?
    @opts = opts
    render_navigation(navmenu_options, &nav_menu)
  end


  def with_prefix(id)
    return id if prefix.nil?
    "#{prefix}_#{id}".to_sym
  end


  def section_name
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


  def renderable?
    true
  end


  def navmenu_options
    { renderer: :bootstrap3, expand_all: true, remove_navigation_class: true, skip_if_empty: true }
  end

end
