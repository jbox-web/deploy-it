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

  SIDEBAR_MENU_TOP_CONTENT    = [:admin, :user_account, :welcome, :application]
  SIDEBAR_MENU_BOTTOM_CONTENT = [:applications, :credentials]


  def render_topbar_menu
    User.current.logged? ? render_menu(:logged_user) : render_menu(:not_logged_user)
  end


  def render_sidebar_menu_top(prefix: nil)
    render_sidebar_menu(SIDEBAR_MENU_TOP_CONTENT, prefix)
  end


  def render_sidebar_menu_bottom(prefix: nil)
    render_sidebar_menu(SIDEBAR_MENU_BOTTOM_CONTENT, prefix)
  end


  def render_sidebar_menu(items, prefix)
    return '' unless User.current.logged?
    items.map { |m| render_menu(m, prefix: prefix) }.compact.join.html_safe
  end


  def current_menu_name
    BaseNavigation.new(self).section_name
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


  def locals_for(menu, &block)
    @locals_for ||= {}
    if block_given?
      @locals_for[menu] = block
    else
      @locals_for[menu]
    end
  end


  def render_menu(menu, opts = {})
    locals = locals_for(:menus)
    locals = locals.call unless locals.nil?
    "#{menu}_navigation".camelize.constantize.new(self, opts).render(locals)
  end

end
