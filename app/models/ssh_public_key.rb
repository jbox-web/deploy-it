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

  SSH_BASE_DIRECTIVES = [
    'no-agent-forwarding',
    'no-port-forwarding',
    'no-X11-forwarding',
    'no-pty',
    'no-user-rc'
  ]

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
  before_validation(on: :create) do
    self.title       = title.strip if !title.nil?
    self.key         = key.strip if !key.nil?
    self.fingerprint = DeployIt::Utils::Ssh.fingerprint(key) if !key.nil?
  end


  def owner
    user.email
  end


  def token
    user.authentication_token
  end


  def ssh_command(script_path)
    [build_ssh_comand(script_path), key].compact.join(' ').strip
  end


  private


    def build_ssh_comand(path)
      args = [path, *ssh_signed_command].compact.join(' ')
      cmd  = "command=\"#{args}\""
      SSH_BASE_DIRECTIVES.clone.push(cmd).join(',').strip
    end


    def ssh_signed_command
      [owner, token, fingerprint].clone
    end


    def has_not_been_changed
      return if new_record?

      %w(user_id title key fingerprint).each do |attribute|
        method = "#{attribute}_changed?"
        errors.add(attribute, 'cannot be changed') if self.send(method)
      end
    end


    def key_correctness
      return if (key.nil? || key.empty?)
      errors.add(:key, :corrupted) if !DeployIt::Utils::Ssh.valid_ssh_public_key?(key)
    end


    def key_uniqueness
      # Validate uniqueness for new record only
      return unless new_record?
      existing = SshPublicKey.find_by_fingerprint(fingerprint)
      if existing
        # Hm.... have a duplicate key!
        if existing.user == User.current
          errors.add(:key, :in_use_by_you, name: existing.title)
        elsif User.current.admin?
          errors.add(:key, :in_use_by_other, login: existing.user.email, name: existing.title)
        else
          errors.add(:key, :in_use_by_someone)
        end
      end
    end

end
