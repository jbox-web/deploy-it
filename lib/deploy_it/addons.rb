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

require 'ostruct'

module DeployIt
  module Addons
    extend self

    def load!(path)
      path = File.join(path, '**', '*.yml')
      data = {}
      Dir.glob(path).each do |file|
        type       = File.basename(file, '.*').to_sym
        settings   = load_file(file).merge(type: type)
        data[type] = klassify(settings)
      end
      data
    end


    def klassify(settings)
      OpenStruct.new(settings)
    end


    def load_file(file)
      YAML::load(ERB.new(IO.read(file)).result).symbolize_keys
    end

  end
end
