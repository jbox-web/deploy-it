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
  module ButtonsHelper

    ## Buttons
    def button_add(url, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = [].push(css_class).compact

      ## Set options
      link_opts = { title: t('button.add'), class: css_class }.merge(link_opts)
      icon_opts = { bigger: false }.merge(icon_opts)

      ## Return link
      link_to_icon('fa-plus', url, link_opts, icon_opts)
    end


    def button_clone(url, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = button_default_css_class.push(css_class).compact

      ## Set options
      link_opts = { title: t('button.clone'), class: css_class }.merge(link_opts)

      ## Return link
      link_to_icon('fa-clone', url, link_opts, icon_opts)
    end


    def button_edit(url, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = button_default_css_class.push(css_class).compact

      ## Set options
      link_opts = { title: t('button.edit'), class: css_class }.merge(link_opts)

      ## Return link
      link_to_icon('fa-edit', url, link_opts, icon_opts)
    end


    def button_refresh(function, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = [].push(css_class).compact

      ## Set options
      link_opts = { title: t('button.refresh'), onclick: function, class: css_class }.merge(link_opts)

      link_to_icon('fa-refresh', '#', link_opts, icon_opts)
    end


    def button_delete(url, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = button_default_css_class.push(css_class).push('btn-danger').compact

      ## Get html options
      confirm = link_opts.delete(:confirm){ true }
      data = confirm ? { confirm: t('text.are_you_sure') } : {}

      ## Set options
      link_opts = { title: t('button.delete'), class: css_class, method: :delete, data: data }.merge(link_opts)

      ## Return link
      link_to_icon('fa-trash-o', url, link_opts, icon_opts)
    end


    def button_cancel(url, link_opts = {}, icon_opts = {})
      ## Get css options
      css_class = link_opts.delete(:class){ nil }
      css_class = button_default_css_class.push(css_class).compact

      ## Set options
      link_opts = { title: t('button.cancel'), label: t('button.cancel'), class: css_class }.merge(link_opts)

      ## Return link
      link_to_icon('fa-close', url, link_opts, icon_opts)
    end


    def button_select_all(function)
      opts = { onclick: function, title: "#{t('button.check_all')}/#{t('button.uncheck_all')}" }
      link_to check_icon(class: 'toggle-checkbox'), '#', opts
    end


    def button_submit(label, opts = {})
      css_class = opts.delete(:class){ nil }
      new_class = ['btn', 'btn-success'].push(css_class).compact
      icon      = opts.delete(:icon){ 'fa-check' }

      button_tag(opts.merge(class: new_class)) do
        label_with_icon(label, icon, fixed: true)
      end
    end


    def button_with_icon(icon)
      content_tag(:button, icon(icon, aligned: false, fixed: true), type: 'button', class: button_default_css_class)
    end


    def remote_toggle_button(url:, label:, id:, value:, checked:, field:, opts: {})
      options = { class: 'bootstrap-switch', data: { switch_callback: 'callToggleUrl(event, checked)', size: 'small', url: url, field: field } }.deep_merge(opts)
      content_tag(:div, id: "switch_#{id}", class: 'toggle-switch') do
        label_tag(id) do
          check_box_tag(id, value, checked, options) + "&nbsp;&nbsp; #{label}".html_safe
        end
      end
    end


    def button_default_css_class
      ['btn', 'btn-default']
    end

  end
end
