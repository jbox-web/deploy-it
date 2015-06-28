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
  module AjaxHelper

    def js_render_template(target, template, opts = {})
      locals = opts.delete(:locals){ {} }
      content = render(template: template, locals: locals)
      js_render(target, content, opts)
    end


    def js_render_partial(target, partial, opts = {})
      locals = opts.delete(:locals){ {} }
      content = render(partial: partial, locals: locals)
      js_render(target, content, opts)
    end


    def js_render(target, content, opts = {})
      method = opts.delete(:method){ :inject }
      "$('#{target}').#{js_rendering_method(method)}(\"#{escape_javascript(content)}\");\n".html_safe
    end


    def js_rendering_method(method)
      case method
      when :append
        'append'
      when :inject
        'html'
      when :replace
        'replaceWith'
      end
    end

  end
end
