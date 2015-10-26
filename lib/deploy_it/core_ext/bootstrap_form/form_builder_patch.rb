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

require 'bootstrap_form/form_builder'

module DeployIt
  module CoreExt
    module BootstrapForm
      module FormBuilderPatch

        def self.included(base)
          base.send(:include, InstanceMethods)
        end


        module InstanceMethods

          def success(name = nil, options = {})
            # Get icon
            icon = options.delete(:icon) { 'fa-check' }

            # Get css options
            css_class = options.delete(:class){ nil }
            css_class = button_default_css_class.push(css_class).push('btn-success').compact

            # Merge options
            options.reverse_merge! class: css_class

            # Render button
            button(options) do
              @template.label_with_icon(name || submit_default_value, icon)
            end
          end


          def cancel(url, options = {})
            @template.link_to I18n.t('button.cancel'), url, class: button_default_css_class
          end


          def continue
            button(name: 'continue', class: 'btn btn-primary') do
              I18n.t('button.continue')
            end
          end


          def back
            button(name: 'back_button', class: 'btn btn-default') do
              I18n.t('button.back')
            end
          end


          private


            def button_default_css_class
              ['btn', 'btn-default']
            end

        end

      end
    end
  end
end

unless BootstrapForm::FormBuilder.included_modules.include?(DeployIt::CoreExt::BootstrapForm::FormBuilderPatch)
  BootstrapForm::FormBuilder.send(:include, DeployIt::CoreExt::BootstrapForm::FormBuilderPatch)
end
