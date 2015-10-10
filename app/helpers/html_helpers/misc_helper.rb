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
  module MiscHelper

    ## Misc
    def display_on_condition(test, condition)
      test == condition ? '' : 'display: none;'
    end


    def disable_on_condition(test, condition)
      add_class_on_condition(test, condition, 'disabled')
    end


    def add_class_on_condition(test, condition, css)
      test == condition ? css : ''
    end


    def html_list(opts = {}, &block)
      opts[:class] = create_array(opts[:class]) if opts.has_key?(:class)
      options = merge_hashes({class: ['list-unstyled']}, opts)
      content_tag(:ul, options) do
        yield block if block_given?
      end
    end


    def merge_hashes(left, right)
      # Merge it with html_options
      left.merge!(right) do |key, oldval, newval|
        (newval.is_a?(Array) ? (oldval + newval) : (oldval << newval)).uniq
      end
      left
    end


    def create_array(object)
      object = object.split(' ') if object.is_a?(String)
      object
    end


    def pp(hash)
      JSON.pretty_generate(hash)
    end


    def render_no_data(type: :info)
      content_tag(:div, t('.none_defined'), class: "alert alert-#{type} dont-dismiss")
    end


    def merge_css_class(opts = {}, default_class = [])
      css_class = opts.delete(:class){ '' }
      css_class = css_class.split(' ')
      new_class = default_class.concat(css_class).compact
      opts[:class] = new_class
      opts
    end

  end
end
