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

class Stage < ActiveRecord::Base

  include HaveDbReferences

  ## Relations
  belongs_to :platform

  has_many :applications

  ## Basic Validations
  validates :name,        presence: true
  validates :platform_id, presence: true
  validates :identifier,  presence: true, uniqueness: { scope: :platform_id }

  ## References checking
  check_db_references :applications

  ## Scopes
  scope :by_name, -> { order(name: :asc) }


  def to_s
    name
  end


  def full_name
    "#{platform.name} - #{name}"
  end

end
