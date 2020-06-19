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

class ApplicationCredential < ApplicationRecord

  ## Relations
  belongs_to :application

  ## Basic Validations
  validates :application_id, presence: true
  validates :login,          presence: true, uniqueness: { case_sensitive: false, scope: [:application_id] }
  validates :password,       presence: true


  def to_hash
    { login: login, password: password }
  end


  def to_ansible
    to_hash.stringify_keys
  end

end
