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

class Platform < ActiveRecord::Base

  ## Relations
  has_many :servers
  has_many :stages
  has_one  :credential, class_name: 'PlatformCredential', dependent: :destroy

  ## Basic Validations
  validates :name,       presence: true, uniqueness: true
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }

  ## Scopes
  scope :by_name, -> { order(name: :asc) }

  ## Callbacks
  before_destroy :check_references


  def to_s
    self.name
  end


  def to_id
    name.downcase.underscore
  end


  def first_server_available_with_role(role)
    selected = nil

    servers_with_role(role).each do |server|
      if server.default_server_for_role?(role) && server.service_online?(role)
        selected = server
        break
      elsif server.service_online?(role)
        selected = server
      end
    end
    selected
  end


  def servers_with_role(role)
    servers.select{ |s| s.has_role?(role) }
  end


  private


    def check_references
      valid = true

      if !servers.empty?
        errors.add(:base, :undeletable, object_name: :server, list: servers.map(&:host_name).to_sentence)
        valid = false
      end

      if !stages.empty?
        errors.add(:base, :undeletable, object_name: :stage, list: stages.map(&:name).to_sentence)
        valid = false
      end

      return valid
    end

end
