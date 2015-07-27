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

require 'uri'

module HtmlHelpers
  module IconsHelper

    def bool_to_icon(bool, opts = {})
      bool ? check_icon(opts) : cross_icon(opts)
    end


    def bool_to_css(bool)
      bool ? '' : 'disabled'
    end


    def repository_icon(url)
      return '' if url.empty?
      uri = URI(url)
      case uri.host
        when 'github.com'
          'fa-github'
        else
          'fa-git'
      end
    end


    ### PRIVATE ###


    def check_icon(opts = {})
      icon('fa-check', { aligned: false, color: '#5cb85c' }, opts)
    end


    def cross_icon(opts = {})
      icon('fa-dot-circle-o', { aligned: false, color: '#a94442' }, opts)
    end


    def stacked_icon(icon_name, opts = {})
      icon_name = icon_name.gsub('fa-', '')
      fa_stacked_icon icon_name, opts
    end


    def icon(icon_name, opts = {}, html_options = {})
      color = opts.delete(:color){ nil }

      # Set icon options
      icon_options = {}
      icon_options[:style] = "color: #{color};" unless color.nil?
      icon_options[:class] = build_icon_css_class(opts).push(icon_name)

      # Treat html_options hash
      html_options[:class] = create_array(html_options[:class])

      # Create a new hash that contains our css class
      options = merge_hashes(icon_options, html_options)

      # Merge our new hash with the rest of opts
      options = merge_hashes(options, opts)

      # Return icon
      content_tag(:i, '', options)
    end


    def build_icon_css_class(opts)
      # Treat opts hash
      inverse = opts.delete(:inverse){ false }
      fixed   = opts.delete(:fixed){ false }
      aligned = opts.delete(:aligned){ true }

      css_class = [ 'fa', 'fa-lg' ]
      css_class.push('fa-align') if aligned
      css_class.push('fa-inverse') if inverse
      css_class.delete('fa-lg') if fixed
      css_class
    end

  end
end
