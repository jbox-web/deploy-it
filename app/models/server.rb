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

require 'resolv'

class Server < ActiveRecord::Base

  include PlatformServer

  ## Relations
  belongs_to :platform

  ## Basic Validations
  validates :host_name,   presence: true, uniqueness: true, length: { maximum: 250 }
  validates :ip_address,  presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }
  validates :platform_id, presence: true
  validates :ssh_user,    presence: true
  validates :ssh_port,    presence: true, numericality: { only_integer: true }

  ## Additionnal Validations
  validate  :valid_hostname

  ## Delegation
  # Platform
  delegate :credential, to: :platform
  # Credential
  delegate :private_key, to: :credential

  ## Scopes
  scope :by_hostname, -> { order(host_name: :asc) }

  ## UseCases
  add_use_cases [ :recreate_inventory_file, :check_connection ]


  def to_s
    host_name
  end


  private


    def valid_hostname
       errors.add(:host_name, :invalid) if !host_name =~ /\A[a-zA-Z0-9\_\-\.]+\z/
    end

end
