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
  class Finder

    attr_reader :singular_name
    attr_reader :params


    def initialize(singular_name, params = {})
      @singular_name = singular_name
      @params        = params
    end


    def render
      ":find_#{singular_name}, #{render_find_options}"
    end


    def render_find_options
      params[:except].any? ? find_params_for(:except) : find_params_for(:only)
    end


    def find_params_for(type)
      find = params[type].map{ |p| ":#{p}" }.join(',')
      "#{type}: [#{find}]"
    end

  end
end
