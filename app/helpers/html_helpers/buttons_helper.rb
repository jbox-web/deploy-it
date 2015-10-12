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
    def button_add(url, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = [].push(css_class).compact

      ## Set options
      opts = {title: t('button.add')}.merge(opts)

      ## Return link
      link_to_with_options(url, 'fa-plus', new_class, opts)
    end


    def button_clone(url, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = button_default_css_class.push(css_class).compact

      ## Set options
      opts = {title: t('button.clone')}.merge(opts)

      ## Return link
      link_to_with_options(url, 'fa-clone', new_class, opts)
    end


    def button_edit(url, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = button_default_css_class.push(css_class).compact

      ## Set options
      opts = {title: t('button.edit')}.merge(opts)

      ## Return link
      link_to_with_options(url, 'fa-edit', new_class, opts)
    end


    def button_delete(url, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = button_default_css_class.push(css_class).compact
      new_class = new_class.push('btn-danger')

      ## Get html options
      confirm = opts.delete(:confirm){ true }
      data = confirm ? { confirm: t('text.are_you_sure') } : {}

      ## Set options
      opts = opts.merge(method: :delete, data: data)
      opts = opts.merge(title: t('button.delete'))

      ## Return link
      link_to_with_options(url, 'fa-trash-o', new_class, opts)
    end


    def button_cancel(url, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = button_default_css_class.push(css_class).compact

      ## Set options
      opts = opts.merge(label: t('button.cancel'), icon: false) if !opts.has_key?(:label)

      ## Return link
      link_to_with_options(url, 'fa-close', new_class, opts)
    end


    def button_select_all(function)
      opts = { onclick: function, title: "#{t('button.check_all')}/#{t('button.uncheck_all')}" }
      link_to check_icon(class: 'toggle-checkbox'), '#', opts
    end


    def button_submit(label, opts = {})
      css_class = opts.delete(:class){ '' }
      new_class = [ 'btn', 'btn-success' ].push(css_class).compact
      icon      = opts.delete(:icon){ 'fa-check' }

      button_tag(class: new_class) do
        label_with_icon(label, icon, fixed: true)
      end
    end


    def button_continue
      button_tag(name: 'continue', class: 'btn btn-primary') do
        t('button.continue')
      end
    end


    def button_back
      button_tag(name: 'back_button', class: 'btn btn-default') do
        t('button.back')
      end
    end


    def button_deploy(container, type, label, opts = {})
      options = {
        method: :post,
        data: {
          remote: true,
          confirm: t('text.are_you_sure')
        }
      }

      wrapper_class = opts.delete(:wrapper_class){ '' }
      wrapper_class = [ 'btn-group' ].push(wrapper_class).compact

      new_class = opts.delete(:class){ '' }.split(' ')
      css_class = [ 'btn', 'btn-default' ].push(new_class).compact

      content_tag(:div, class: wrapper_class) do
        button_with_form(deploy_path(container), options) do
          hidden_field_tag(:type, type.to_s) +
          button_tag(class: css_class) do
            label
          end
        end
      end
    end


    def button_with_form(url, opts = {}, &block)
      form_tag(url, opts) do
         yield if block_given?
      end
    end


    def button_refresh(function, opts = {})
      ## Get css options
      css_class = opts.delete(:class){ nil }
      new_class = [].push(css_class).compact

      ## Set options
      opts = {title: t('button.refresh'), label: t('button.refresh'), onclick: function}.merge(opts)

      link_to_with_options('#', 'fa-refresh', new_class, opts)
    end


    def link_to_with_options(url, icon_name, css_class = [], opts = {})
      text_label = opts.delete(:label){ false }
      show_icon  = opts.delete(:icon){ true }

      if text_label
        icon_opts = { fixed: true, aligned: true }
      else
        icon_opts = { fixed: true, aligned: false }
      end

      if show_icon
        label = text_label ? label_with_icon(text_label, icon_name, icon_opts) : icon(icon_name, icon_opts)
      else
        label = text_label
      end

      opts[:class] = css_class.join(' ')

      link_to label, url, opts
    end


    def button_default_css_class
      ['btn', 'btn-default'].clone
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

  end
end
