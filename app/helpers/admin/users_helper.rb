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

module Admin::UsersHelper

  def options_for_membership_application_select(user, applications)
    options = content_tag(:option, "--- #{t('helpers.select.prompt')} ---", value: '')
    options << applications_list_options_for_select(applications) do |p|
      {:disabled => user.applications.to_a.include?(p)}
    end
    options
  end


  def applications_list_options_for_select(applications, options = {})
    s = ''
    applications.each do |application|
      tag_options = {:value => application.id}
      if application == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(application))
        tag_options[:selected] = 'selected'
      else
        tag_options[:selected] = nil
      end
      tag_options.merge!(yield(application)) if block_given?
      s << content_tag(:option, application.name, tag_options)
    end
    s.html_safe
  end

end
