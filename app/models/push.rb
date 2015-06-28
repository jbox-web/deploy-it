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

class Push < ActiveRecord::Base

  ## Relations
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :application

  ## Basic Validations
  validates :author_id,      presence: true
  validates :application_id, presence: true
  validates :ref_name,       presence: true
  validates :old_revision,   presence: true
  validates :new_revision,   presence: true

end
