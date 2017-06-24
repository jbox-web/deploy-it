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

class ApplicationAddon < ApplicationRecord

  # Disable STI for this class
  self.inheritance_column = 'types'

  ## Relations
  belongs_to :application

  ## Basic Validations
  validates :application_id, presence: true
  validates :type,           presence: true, uniqueness: { scope: :application_id }, inclusion: { in: DeployIt.addons_available }


  def to_s
    name
  end


  def stype
    type.to_sym
  end


  def name
    DeployIt.addons[stype][:name] || type.capitalize
  end


  def image_name
    DeployIt.addons[stype][:image]
  end


  def port
    DeployIt.addons[stype][:port]
  end


  def url
    DeployIt.addons[stype][:url] || ''
  end


  def icon
    DeployIt.addons[stype][:icon] || ''
  end

end
