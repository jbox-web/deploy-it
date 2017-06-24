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

class ContainerEvent < ApplicationRecord

  # Disable STI for this class
  self.inheritance_column = 'types'

  ## Relations
  belongs_to :container

  ## Basic Validations
  validates :container_id, presence: true
  validates :type,         presence: true
  validates :message,      presence: true

  scope :unknow_process, -> { where(type: 'unknown_process') }
  scope :not_seen,       -> { where(seen: false) }


  def to_s
    "#{type} : #{message}"
  end


  def seen!
    update_attribute(:seen, true)
  end

end
