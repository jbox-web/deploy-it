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

class SslCertificate < ActiveRecord::Base

  ## Relations
  belongs_to :application

  ## Basic Validations
  validates :application_id, presence: true, uniqueness: true
  validates :ssl_crt,        presence: true
  validates :ssl_key,        presence: true

  ## Additionnal Validations
  validate :key_correctness
  validate :key_match_cert


  private


    def key_correctness
      return if (ssl_crt.nil? || ssl_key.nil?)
      return if (ssl_crt.empty? || ssl_key.empty?)
      errors.add(:ssl_crt, :corrupted) if !DeployIt::Utils::Ssl.valid_ssl_cert?(ssl_crt)
      errors.add(:ssl_key, :corrupted) if !DeployIt::Utils::Ssl.valid_ssl_key?(ssl_key)
    end


    def key_match_cert
      return if (ssl_crt.nil? || ssl_key.nil?)
      return if (ssl_crt.empty? || ssl_key.empty?)
      errors.add(:base, :key_match_cert) if !DeployIt::Utils::Ssl.key_match_cert?(ssl_key, ssl_crt)
    end

end
