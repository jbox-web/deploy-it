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

module ActsAs
  module SshCredential
    extend ActiveSupport::Concern

    included do
      ## Basic Validations
      validates :public_key,  presence: true
      validates :private_key, presence: true
      validates :fingerprint, presence: true

      ## Additionnal Validations
      validate :key_correctness

      ## Callbacks
      before_validation :strip_whitespace
      before_validation :set_fingerprint
    end


    private


      # Strip leading and trailing whitespace
      def strip_whitespace
        # Don't mess with existing keys (since cannot change key text anyway)
        return unless new_record?
        self.public_key  = public_key.strip rescue ''
        self.private_key = private_key.strip rescue ''
      end


      def set_fingerprint
        # Don't mess with existing keys (since cannot change key text anyway)
        return unless new_record?
        self.fingerprint = DeployIt::SshUtils.fingerprint(public_key)
      end


      def key_correctness
        return if (public_key.nil? || private_key.nil?)
        return if (public_key.empty? || private_key.empty?)

        valid = true

        if !DeployIt::SshUtils.valid_ssh_public_key?(public_key)
          errors.add(:public_key, :corrupted)
          valid = false
        end

        if !DeployIt::SshUtils.valid_ssh_private_key?(private_key)
          errors.add(:private_key, :corrupted)
          valid = false
        end

        return valid
      end

  end
end
