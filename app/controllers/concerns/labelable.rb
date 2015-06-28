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

module Labelable

  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
    include ActionView::Helpers::TagHelper

    def label_with_icon(label, icon, opts = {})
      inverse = opts.delete(:inverse) || false
      fixed   = opts.delete(:fixed) || false

      css_class = [ 'fa', 'fa-lg', 'fa-align' ]

      css_class.push(icon)

      if inverse
        css_class.push("fa-inverse")
      end

      if fixed
        # css_class.push("fa-fw")
        css_class.delete("fa-lg")
      end

      css_class = css_class.join(" ")
      content = content_tag(:i, '', :class => css_class) + label

      return content.html_safe
    end
  end

  module InstanceMethods

    def label_with_icon(*args)
      self.class.label_with_icon(*args)
    end

  end

end
