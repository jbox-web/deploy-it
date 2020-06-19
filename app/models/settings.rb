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

require 'settingslogic'

class Settings < Settingslogic
  source Rails.root.join('config', 'settings.yml')
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  def grouped(nb = 4)
    grouped = []
    APPLICATION_CONFIG.keys.in_groups_of(nb).each do |keys|
      group = {}
      keys.each do |key|
        next if key.blank?
        group[key] = {}
        if key == :rails_config
          group[key]['RUBY_VERSION']  = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
          group[key]['RAILS_VERSION'] = Rails::VERSION::STRING
        end
        APPLICATION_CONFIG[key].each do |value|
          group[key][value] = ENV[value]
        end
      end
      grouped << group
    end
    grouped
  end

end
