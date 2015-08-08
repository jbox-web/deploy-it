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

module HtmlHelpers
  module NavmenuHelper

    def nav_menu(opts = {}, &block)
      opts = { role: 'navigation', class: 'navmenu navmenu-default' }.merge(opts)
      menu = capture(&block).strip
      !menu.empty? ? content_tag(:div, menu.html_safe, opts) : ''
    end


    def responsive_nav_menu(id, opts = {}, &block)
      navbar_name = opts.fetch(:navbar_name)
      navbar_id   = opts.fetch(:navbar_id)
      target      = "##{id}"

      container_options = { id: id, role: 'navigation', class: ['navmenu-inverse', 'navmenu-fixed-left', 'offcanvas'] }
      container_options = merge_css_class(container_options, ['navmenu', 'navmenu-default'])

      menu_content = nav_menu(container_options, &block)

      if !menu_content.strip.empty?
        render_hidden_menu(navbar_name, navbar_id, target, :canvas) +
        menu_content
      else
        ''
      end
    end


    private


      def render_hidden_menu(name, id, target, button_type)
        container_options = { id: id, class: hidden_menu_css_class(button_type) }

        content_tag(:div, container_options) do
          toggle_button(target, hidden_menu_html_options(button_type)) +
          content_tag(:a, name, href: '#', class: 'navbar-brand')
        end
      end


      def hidden_menu_html_options(type)
        case type
        when :canvas
          { toggle: 'offcanvas', recalc: 'false', canvas: 'body' }
        when :collapse
          { toggle: 'collapse' }
        end
      end


      def hidden_menu_css_class(type)
        case type
        when :canvas
          ['navbar', 'navbar-default', 'navbar-fixed-top', 'hidden-sm', 'hidden-md', 'hidden-lg']
        when :collapse
          ['navbar-header']
        end
      end


      def toggle_button(target, opts = {})
        content_tag(:button, class: 'navbar-toggle', data: opts.merge(target: target)) do
          content_tag(:span, '', class: 'icon-bar') +
          content_tag(:span, '', class: 'icon-bar') +
          content_tag(:span, '', class: 'icon-bar')
        end
      end

  end
end
