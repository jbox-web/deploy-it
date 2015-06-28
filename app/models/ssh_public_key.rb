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

class SshPublicKey < ActiveRecord::Base

  ## Relations
  belongs_to :user

  ## Basic Validations
  validates :user_id,     presence: true
  validates :title,       presence: true
  validates :key,         presence: true
  validates :fingerprint, presence: true

  ## Additionnal Validations
  validate :has_not_been_changed
  validate :key_correctness
  validate :key_uniqueness

  ## Callbacks
  before_validation :strip_whitespace
  before_validation :set_fingerprint

  ## UseCases
  add_use_cases [ :add_to_authorized_keys, :remove_from_authorized_keys ]


  class << self

    def authorized_key_file
      Settings.ssh_config_file
    end

  end


  def owner
    user.login
  end


  def exists_in_authorized_key_file?
    line = File.open(self.class.authorized_key_file, 'r') { |f| f.each_line.detect { |line| /#{fingerprint}/.match(line) } }
    !line.nil?
  rescue Errno::ENOENT
    false
  end


  private


    # Strip leading and trailing whitespace
    def strip_whitespace
      # Don't mess with existing keys (since cannot change key text anyway)
      return unless new_record?
      self.title = title.strip rescue ''
      self.key   = key.strip rescue ''
    end


    def set_fingerprint
      # Don't mess with existing keys (since cannot change key text anyway)
      return unless new_record?
      self.fingerprint = DeployIt::SshUtils.fingerprint(key)
    end


    def has_not_been_changed
      return if new_record?

      valid = true

      %w(user_id title key fingerprint).each do |attribute|
        method = "#{attribute}_changed?"
        if self.send(method)
          errors.add(attribute, 'cannot be changed')
          valid = false
        end
      end

      return valid
    end


    def key_correctness
      return false if (key.nil? || key.empty?)

      if !DeployIt::SshUtils.valid_ssh_public_key?(key)
        errors.add(:key, :corrupted)
        return false
      end
    end


    def key_uniqueness
      # Validate uniqueness for new record only
      return unless new_record?

      existing = SshPublicKey.find_by_fingerprint(fingerprint)

      if existing
        # Hm.... have a duplicate key!
        if existing.user == User.current
          errors.add(:key, :in_use_by_you, name: existing.title)
          return false
        elsif User.current.admin?
          errors.add(:key, :in_use_by_other, login: existing.user.login, name: existing.title)
          return false
        else
          errors.add(:key, :in_use_by_someone)
          return false
        end
      end

      return true
    end

end
