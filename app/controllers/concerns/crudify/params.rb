# frozen_string_literal: true
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

module Crudify
  class Params

    attr_reader :singular_name
    attr_reader :params


    def initialize(singular_name, params = {})
      @singular_name = singular_name
      @params        = params
    end


    def render(type)
      options = convert_params_to_symbol(type).join(',')
      "params.require(:#{singular_name}).permit(#{options})"
    end


    def convert_params_to_symbol(type)
      options =
        params[type].map{ |p|
          case p.class.name
          when 'Symbol'
            ":#{p}"
          when 'Hash'
            content = +''
            p.each do |key, values|
             content << "#{key}: #{values}"
            end
            content
          end
        }
      options
    end

  end
end
