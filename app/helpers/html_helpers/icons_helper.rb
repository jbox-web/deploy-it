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


    def check_icon(opts = {})
      icon 'fa-check', { aligned: false, color: '#5cb85c' }.merge(opts)
    end


    def cross_icon(opts = {})
      icon 'fa-dot-circle-o', { aligned: false, color: '#a94442' }.merge(opts)
    end


    def stacked_icon(name, opts = {})
      name = name.gsub('fa-', '')
      fa_stacked_icon(name, opts)
    end


    def icon(name, opts = {})
      options   = opts.dup
      color     = options.delete(:color){ nil }
      css_class = options.delete(:class){ [] }
      css_class = create_array(css_class)

      # Set icon options
      icon_options = {}
      icon_options[:style] = "color: #{color};" unless color.nil?
      icon_options[:class] = build_icon_css_class(options).push(name)
      icon_options[:class] = icon_options[:class].concat(css_class).uniq.compact

      # Merge our new hash with the rest of options
      icon_options = merge_hashes(icon_options, options)

      # Return icon
      content_tag(:i, '', icon_options)
    end


    private


      def build_icon_css_class(opts)
        # Treat opts hash
        inverse = opts.delete(:inverse) { false }
        fixed   = opts.delete(:fixed)   { false }
        aligned = opts.delete(:aligned) { true }
        bigger  = opts.delete(:bigger)  { true }

        css_class = ['fa']
        css_class.push('fa-lg') if bigger
        css_class.push('fa-align') if aligned
        css_class.push('fa-inverse') if inverse
        css_class.push('fa-fw') if fixed
        css_class
      end

  end
end
