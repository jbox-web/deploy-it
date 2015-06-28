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

class Release < ActiveRecord::Base

  ## Relations
  belongs_to :application
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :build
  belongs_to :config

  ## Basic Validations
  validates :application_id, presence: true
  validates :author_id,      presence: true
  validates :build_id,       presence: true
  validates :config_id,      presence: true
  validates :version,        presence: true

  before_validation :set_version

  ## Delegations
  delegate :ref_name, :old_revision, :new_revision, to: :build


  def revision
    new_revision
  end


  def set_version
    return if application_id.nil?
    max_version = Release.where(application_id: application_id).maximum(:version)
    self.version = max_version.to_i + 1
  end

end
